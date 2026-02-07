import SwiftUI

struct MediaListView: View {
    enum ListType: Hashable {
        case trendingMovies
        case popularMovies
        case topRatedMovies
        case trendingTV
        case popularTV
        case kDrama
        case chineseMovies
        case bollywoodMovies
        case genre(id: Int)
        case provider(id: Int)
        case newReleases
        case upcoming
        case topTen
        case forYou
        case trending
        case fixed(title: String, items: [MediaItem]) // For fixed/passed items (e.g. Home For You)
        
        var title: String {
            switch self {
            case .trendingMovies: return "Trending Movies"
            case .popularMovies: return "Popular Movies"
            case .topRatedMovies: return "Top Rated Movies"
            case .trendingTV: return "Trending TV Shows"
            case .popularTV: return "Popular TV Shows"
            case .genre: return "Genre"
            case .kDrama: return "K-Drama"
            case .chineseMovies: return "Chinese Movies"
            case .bollywoodMovies: return "Bollywood Movies"
            case .provider: return "Content"
            case .newReleases: return "New Releases"
            case .upcoming: return "Coming Soon"
            case .topTen: return "Top 10 on Flux"
            case .forYou: return "For You"
            case .trending: return "Trending Now"
            case .fixed(let title, _): return title
            }
        }
    }
    
    let title: String
    let type: ListType
    @State private var items: [MediaItem] = []
    @State private var isLoading = false
    @State private var currentPage = 1
    @State private var canLoadMore = true
    
    init(title: String? = nil, type: ListType) {
        self.type = type
        self.title = title ?? type.title
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 24)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                content
            }
            .padding(40)
        }
        .background(Color.black.opacity(0.9)) // Dark background for contrast
        .task {
            // Set loading explicitly for first load to avoid empty flash if possible, 
            // though loadData handles it too. 
            // Actually, we rely on loadData setting it true.
            await loadData()
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if isLoading && items.isEmpty { // Only full screen loader if no items
            ProgressView()
                .controlSize(.large)
                .frame(maxWidth: .infinity, minHeight: 200)
        } else {
            LazyVGrid(columns: columns, spacing: 40) {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        GlassCard(item: item, aspectRatio: aspectRatio)
                    }
                    .buttonStyle(.plain)
                    .focusEffectDisabled()
                    .onAppear {
                        if item == items.last {
                            Task { await loadData() }
                        }
                    }
                }
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
        }
    }
    
    private var aspectRatio: CardAspectRatio {
        switch type {
        case .trendingTV, .popularTV, .kDrama:
            return .landscape
        default:
            return .portrait
        }
    }
    
    private func loadData(reset: Bool = false) async {
        if reset {
            items = []
            currentPage = 1
            canLoadMore = true
        }
        
        guard canLoadMore, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        // Loop to fetch pages until we find items or hit a limit (max 5 empty pages to prevent infinite loop)
        var emptyPageCount = 0
        var foundItems = false
        
        while !foundItems && canLoadMore && emptyPageCount < 5 {
            do {
                var newItems: [MediaItem] = []
                
                switch type {
                case .trendingMovies:
                    let movies = try await TMDBService.shared.fetchTrendingMovies(page: currentPage)
                    newItems = movies.map { $0.toMediaItem() }
                case .popularMovies:
                    let movies = try await TMDBService.shared.fetchPopularMovies(page: currentPage)
                    newItems = movies.map { $0.toMediaItem() }
                case .topRatedMovies:
                    let movies = try await TMDBService.shared.fetchTopRatedMovies(page: currentPage)
                    newItems = movies.map { $0.toMediaItem() }
                case .trendingTV:
                    let tv = try await TMDBService.shared.fetchTrendingTVShows(page: currentPage)
                    newItems = tv.map { $0.toMediaItem() }
                case .popularTV:
                    let tv = try await TMDBService.shared.fetchPopularTVShows(page: currentPage)
                    newItems = tv.map { $0.toMediaItem() }
                case .genre(let id):
                    let movies = try await TMDBService.shared.fetchMoviesByGenre(genreId: id, page: currentPage)
                    newItems = movies.map { $0.toMediaItem() }
                case .kDrama:
                    let tv = try await TMDBService.shared.fetchKDrama(page: currentPage)
                    newItems = tv.map { $0.toMediaItem() }
                case .chineseMovies:
                    let movies = try await TMDBService.shared.fetchChineseMovies(page: currentPage)
                    newItems = movies.map { $0.toMediaItem() }
                case .bollywoodMovies:
                    let movies = try await TMDBService.shared.fetchBollywoodMovies(page: currentPage)
                    newItems = movies.map { $0.toMediaItem() }
                case .provider(let id):
                    async let movies = TMDBService.shared.fetchMovies(byProviderId: id, page: currentPage)
                    async let tv = TMDBService.shared.fetchTV(byProviderId: id, page: currentPage)
                    let (m, t) = try await (movies, tv)
                    newItems = (m.map { $0.toMediaItem() } + t.map { $0.toMediaItem() }).shuffled()
                case .newReleases:
                    async let movies = TMDBService.shared.fetchNowPlayingMovies(page: currentPage)
                    async let tv = TMDBService.shared.fetchAiringTodayTV(page: currentPage)
                    let (m, t) = try await (movies, tv)
                    newItems = (m.map { $0.toMediaItem() } + t.map { $0.toMediaItem() })
                        .sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) }
                case .upcoming:
                    async let movies = TMDBService.shared.fetchUpcomingMovies(page: currentPage)
                    async let tv = TMDBService.shared.fetchOnTheAirTV(page: currentPage)
                    let (m, t) = try await (movies, tv)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let today = Date()
                    
                    newItems = (m.map { $0.toMediaItem() } + t.map { $0.toMediaItem() })
                        .filter { item in
                            guard let dateString = item.releaseDate,
                                  let date = dateFormatter.date(from: dateString) else { return false }
                            return date >= today
                        }
                        .sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) } // Popularity Descending
                case .topTen:
                    async let movies = TMDBService.shared.fetchTrendingMovies(page: currentPage)
                    async let tv = TMDBService.shared.fetchTrendingTVShows(page: currentPage)
                    let (m, t) = try await (movies, tv)
                    newItems = (m.map { $0.toMediaItem() } + t.map { $0.toMediaItem() })
                        .sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) }
                case .forYou:
                    async let trM = TMDBService.shared.fetchTopRatedMovies(page: currentPage)
                    async let popT = TMDBService.shared.fetchPopularTVShows(page: currentPage)
                    let (m, t) = try await (trM, popT)
                    newItems = (m.map { $0.toMediaItem() } + t.map { $0.toMediaItem() }).shuffled()
                case .trending:
                    async let movies = TMDBService.shared.fetchTrendingMovies(page: currentPage)
                    async let tv = TMDBService.shared.fetchTrendingTVShows(page: currentPage)
                    let (m, t) = try await (movies, tv)
                    newItems = (m.map { $0.toMediaItem() } + t.map { $0.toMediaItem() })
                        .sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) }
                case .fixed(_, let fixedItems):
                    if currentPage == 1 { newItems = fixedItems }
                    canLoadMore = false
                }
                
                // Deduplicate
                let existingIDs = Set(items.map { $0.id })
                let uniqueItems = newItems.filter { !existingIDs.contains($0.id) }
                
                if !uniqueItems.isEmpty {
                    items.append(contentsOf: uniqueItems)
                    foundItems = true
                } else {
                    // If we fetched data but it was all filtered out (e.g. upcoming),
                    // we count it as an empty page but CONTINUE trying (increment page)
                    // only if it wasn't a "Fixed" list which logic handles above.
                    if case .fixed = type {
                        foundItems = true // Break loop
                    } else if newItems.isEmpty {
                        // Truly end of results from API?
                        // If API returned 0 results, we stop.
                        // But we don't know easily if API returned 0 or if we filtered 20 -> 0.
                        // For mixed lists (movie+tv), it's harder to know.
                        // Heuristic: If we are in .upcoming and filtered everything, keep going.
                        // Ideally we'd check if `m` and `t` were empty from API.
                        // For now, we assume if we filtered everything, we try next page.
                         emptyPageCount += 1
                    } else {
                         // IDs were just invalid/duplicates, try next page
                         emptyPageCount += 1
                    }
                }
                
                if foundItems || emptyPageCount < 5 {
                     currentPage += 1
                } else {
                    canLoadMore = false
                }
                
            } catch {
                print("Error fetching list data: \(error)")
                canLoadMore = false // Stop on error
                foundItems = true // Break loop
            }
        }
        
        isLoading = false
    }
}

#Preview {
    MediaListView(title: "Action", type: .genre(id: 28))
}
