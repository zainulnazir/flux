import SwiftUI

struct DownloadsView: View {
    // Mock downloads data using a different subset of sample media
    let downloadItems: [MediaItem] = []
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 24)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                if downloadItems.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "arrow.down.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No Downloads")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Downloaded movies and shows will appear here.")
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                } else {
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(downloadItems) { item in
                            NavigationLink(value: item) {
                                GlassCard(item: item, aspectRatio: .portrait)
                                    .overlay(alignment: .topTrailing) {
                                        Image(systemName: "checkmark.circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .shadow(radius: 2)
                                    }
                            }
                            .buttonStyle(.plain)
                            .focusEffectDisabled()
                        }
                    }
                }
            }
            .padding(40)
        }
        .background(Color.black.opacity(0.9))
        .navigationTitle("Downloads")
    }
}

#Preview {
    DownloadsView()
}
