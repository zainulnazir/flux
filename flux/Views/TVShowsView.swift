import SwiftUI

struct TVShowsView: View {
    @State private var popularShows: [MediaItem] = []
    @State private var trendingShows: [MediaItem] = []
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 48) {
                if isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .frame(maxWidth: .infinity)
                        .frame(height: 500)
                } else {
                    // Featured Show
                    if let featured = popularShows.first {
                        HeroView(item: featured)
                            .frame(height: 500)
                    }
                    
                    // Popular Shows Grid
                    if !popularShows.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Popular Shows", destination: MediaListView(type: .popularTV))
                                .padding(.horizontal, 40)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), spacing: 24)], spacing: 40) {
                                ForEach(popularShows) { item in
                                    NavigationLink(value: item) {
                                        GlassCard(item: item, aspectRatio: .landscape)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    
                    // Trending Shows Grid
                    if !trendingShows.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Trending Now", destination: MediaListView(type: .trendingTV))
                                .padding(.horizontal, 40)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), spacing: 24)], spacing: 40) {
                                ForEach(trendingShows) { item in
                                    NavigationLink(value: item) {
                                        GlassCard(item: item, aspectRatio: .landscape)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                }
            }
            .padding(.bottom, 80)
        }
        .ignoresSafeArea(edges: .top)
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            async let popular = TMDBService.shared.fetchPopularTVShows()
            async let trending = TMDBService.shared.fetchTrendingTVShows()
            
            let (p, t) = try await (popular, trending)
            
            popularShows = p.map { $0.toMediaItem() }
            trendingShows = t.map { $0.toMediaItem() }
            isLoading = false
        } catch {
            print("Error fetching TV shows: \(error)")
            isLoading = false
        }
    }
}

#Preview {
    TVShowsView()
}
