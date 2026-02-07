import SwiftUI

struct ContinueWatchingRow: View {
    let items: [MediaItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Continue Watching")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            VStack(alignment: .leading, spacing: 0) {
                                ZStack(alignment: .bottom) {
                                    AsyncImage(url: item.imageURL) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        default:
                                            Rectangle().fill(Color.gray.opacity(0.3))
                                        }
                                    }
                                    .frame(width: 280, height: 160)
                                    .clipped()
                                    
                                    // Progress Bar
                                    if let progress = item.progress {
                                        GeometryReader { geo in
                                            ZStack(alignment: .leading) {
                                                Rectangle()
                                                    .fill(Color.white.opacity(0.3))
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .frame(width: geo.size.width * progress)
                                            }
                                        }
                                        .frame(height: 6)
                                    }
                                }
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                                
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }
                            .frame(width: 280)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        ContinueWatchingRow(items: MockData.sampleMedia)
    }
}
