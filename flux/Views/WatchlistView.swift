import SwiftUI

struct WatchlistView: View {
    @ObservedObject var userData = UserDataService.shared
    @Binding var selectedTab: SidebarItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "bookmark.fill")
                        .font(.title)
                        .foregroundStyle(.pink)
                    Text("My Watchlist")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                if userData.watchlist.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("Your watchlist is empty")
                            .font(.title3)
                            .fontWeight(.medium)
                        Text("Add movies and shows to watch them later")
                            .foregroundStyle(.secondary)
                        
                        Button("Find Something to Watch") {
                            selectedTab = .home
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                    .frame(maxWidth: .infinity, minHeight: 400)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 20)], spacing: 24) {
                        ForEach(userData.watchlist) { item in
                            NavigationLink(value: item) {
                                GlassCard(item: item, aspectRatio: .portrait)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color.black)
        .navigationTitle("Watchlist")
    }
}

#Preview {
    WatchlistView(selectedTab: .constant(.watchlist))
}
