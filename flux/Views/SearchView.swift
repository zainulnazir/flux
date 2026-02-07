import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [MediaItem] = []
    @State private var isSearching = false
    @ObservedObject private var searchManager = SearchManager.shared
    
    // Grid for Vertical Genre Cards (160px width)
    let genreColumns = [
        GridItem(.adaptive(minimum: 160), spacing: 24)
    ]
    
    // Grid for Search Results
    let resultColumns = [
        GridItem(.adaptive(minimum: 160), spacing: 24)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                if isSearching {
                    searchResultsView
                } else {
                    defaultBrowseView
                }
            }
            .padding(40)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                CenteredSearchField(text: $searchText, onSubmit: {
                    Task {
                        await performSearch()
                    }
                })
                .frame(width: 400)
            }
        }
        .onChange(of: searchText) { _, newValue in
             if newValue.isEmpty {
                 isSearching = false
                 searchResults = []
             }
         }
        .task(id: searchText) {
            guard !searchText.isEmpty else { return }
            try? await Task.sleep(nanoseconds: 800_000_000) // 0.8s debounce
            if Task.isCancelled { return }
            await performSearch()
        }
    }
    
    // ... (rest of view code)
    
    private func performSearch() async {
        guard !searchText.isEmpty else { return }
        isSearching = true
        
        let query = searchText
        
        // Run heavy logic in background
        let results: [MediaItem] = await Task.detached(priority: .userInitiated) {
            let rawQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
            var actualQuery = rawQuery
            var searchYear: Int? = nil
            
            // 1. Smart Year Extraction
            if let yearMatch = try? NSRegularExpression(pattern: "\\s(\\d{4})$").firstMatch(in: rawQuery, range: NSRange(rawQuery.startIndex..., in: rawQuery)) {
                if let range = Range(yearMatch.range(at: 1), in: rawQuery),
                   let year = Int(rawQuery[range]) {
                    searchYear = year
                    actualQuery = String(rawQuery[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
                }
            }
            
            do {
                var (movies, tvShows) = try await TMDBService.shared.searchMulti(query: actualQuery)
                
                // 2. Fuzzy Fallback
                if movies.isEmpty && tvShows.isEmpty && !actualQuery.contains(" ") {
                    let fuzzyQuery = actualQuery.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression, range: nil)
                    if fuzzyQuery != actualQuery {
                         (movies, tvShows) = try await TMDBService.shared.searchMulti(query: fuzzyQuery)
                    }
                }
                
                // 3. Filter by Year
                var movieItems = movies.map { $0.toMediaItem() }
                var tvItems = tvShows.map { $0.toMediaItem() }
                
                if let targetYear = searchYear {
                     movieItems = movieItems.filter { item in
                         guard let date = item.releaseDate, let itemYear = Int(date.prefix(4)) else { return false }
                         return abs(itemYear - targetYear) <= 1
                     }
                     tvItems = tvItems.filter { item in
                         guard let date = item.releaseDate, let itemYear = Int(date.prefix(4)) else { return false }
                         return abs(itemYear - targetYear) <= 1
                     }
                }
                
                var combined = movieItems + tvItems
                let queryLower = actualQuery.lowercased()
                
                combined.sort { item1, item2 in
                    let title1 = item1.title.lowercased()
                    let title2 = item2.title.lowercased()
                    
                    if title1 == queryLower && title2 != queryLower { return true }
                    if title2 == queryLower && title1 != queryLower { return false }
                    
                    let startsWith1 = title1.hasPrefix(queryLower)
                    let startsWith2 = title2.hasPrefix(queryLower)
                    
                    if startsWith1 && !startsWith2 { return true }
                    if startsWith2 && !startsWith1 { return false }
                    
                    return (item1.popularity ?? 0) > (item2.popularity ?? 0)
                }
                
                return combined
            } catch {
                print("Error searching: \(error)")
                return []
            }
        }.value
        
        await MainActor.run {
            self.searchResults = results
        }
    }

    
    // MARK: - Subviews
    
    private var searchResultsView: some View {
        LazyVGrid(columns: resultColumns, spacing: 24) {
            ForEach(searchResults) { item in
                NavigationLink(value: item) {
                    GlassCard(item: item, aspectRatio: .portrait)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var defaultBrowseView: some View {
        VStack(alignment: .leading, spacing: 40) {
            // Recent Searches
            if !searchManager.recentSearches.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Searches")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(searchManager.recentSearches) { item in
                                NavigationLink(value: item) {
                                    WideSearchCard(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            
            // Browse by Genre
            VStack(alignment: .leading, spacing: 16) {
                Text("Browse by Genre")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                LazyVGrid(columns: genreColumns, spacing: 16) {
                    ForEach(Genre.allGenres, id: \.id) { genre in
                        NavigationLink(destination: MediaListView(title: genre.name, type: .genre(id: genre.id))) {
                            GenreCard(genre: genre)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

// Custom Wide Card for Recent Searches
struct WideSearchCard: View {
    let item: MediaItem
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Thumbnail
            CachedImage(url: item.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 90) // Portrait thumbnail
                        .clipped()
                        .cornerRadius(8)
                default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 90)
                        .cornerRadius(8)
                }
            }
            
            // Text Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(formatSubtitle(item))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(12)
        .frame(width: 300, height: 114) // Wide card fixed size
        .background(Color.white.opacity(isHovering ? 0.15 : 0.08)) // Dark glass bg
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(isHovering ? 0.3 : 0.0), lineWidth: 1)
        )
        .scaleEffect(isHovering ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
    }
    
    private func formatSubtitle(_ item: MediaItem) -> String {
        var parts: [String] = []
        parts.append(item.category) // Movie / TV Show
        
        // Add Year if available
        if let date = item.releaseDate, date.count >= 4 {
            let year = String(date.prefix(4))
            parts.append(year)
        }
        
        return parts.joined(separator: " • ")
    }
}

#Preview {
    SearchView()
}
