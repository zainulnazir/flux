import SwiftUI

struct HistoryView: View {
    @ObservedObject private var userData = UserDataService.shared
    
    var showAsContinueWatching: Bool = false
    @Environment(\.openWindow) private var openWindow
    
    // Adaptive columns based on mode
    var columns: [GridItem] {
        if showAsContinueWatching {
            return [GridItem(.adaptive(minimum: 280), spacing: 24)]
        } else {
            return [GridItem(.adaptive(minimum: 160), spacing: 24)]
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                if userData.history.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "clock")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text(showAsContinueWatching ? "No Continue Watching Items" : "No Watch History")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Movies and shows you watch will appear here.")
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                } else {
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(userData.history) { item in
                            if showAsContinueWatching {
                                Button(action: {
                                    // Direct Play
                                    PlayerManager.shared.play(item, season: item.lastSeason, episode: item.lastEpisode, episodeImage: item.lastEpisodeImage)
                                    openWindow(id: "player", value: item.id)
                                }) {
                                    ContinueWatchingCard(item: item)
                                }
                                .buttonStyle(.plain)
                            } else {
                                NavigationLink(value: item) {
                                    GlassCard(item: item, aspectRatio: .portrait)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(40)
        }
        .background(Color.black.opacity(0.9))
        .navigationTitle(showAsContinueWatching ? "Continue Watching" : "History")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(showAsContinueWatching ? "Continue Watching" : "History")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
            }
        }
    }
}

#Preview {
    HistoryView()
}
