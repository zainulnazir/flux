import SwiftUI

struct EpisodeCard: View {
    let episode: Episode
    var progress: Double? = nil
    
    
    @State private var isHovered = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Upper 90%: Thumbnail Area
                ZStack(alignment: .bottom) {
                    CachedImage(url: episode.stillURL) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fill)
                        default:
                            ZStack {
                                Rectangle().fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                                Image(systemName: "photo").foregroundStyle(.secondary)
                            }
                        }
                    }
                    .frame(width: 250, height: 225) // 90% of 250
                    .clipped()
                    
                    // "Mild blur to the lower 40% of that 90%"
                    // 40% of 225 is 90
                    GeometryReader { geo in
                         CachedImage(url: episode.stillURL) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 225)
                                    .clipped()
                                    .blur(radius: 20)
                                    .mask(
                                        VStack(spacing: 0) {
                                            Spacer()
                                            Rectangle().frame(height: 90) // Bottom 40%
                                        }
                                    )
                            }
                        }
                    }
                    .frame(width: 250, height: 225)
                    .allowsHitTesting(false)
                }
                .frame(width: 250, height: 225)
                
                // Remaining 10%: Gradient/Footer
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.8), .black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 250, height: 25)
            }
            
            // Content Overlay (Sitting on the blurred/gradient bottom area)
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                
                Text(episode.name)
                    .font(.headline) // Apple TV style
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    if let runtime = episode.runtime {
                        Text("\(runtime)m")
                    } else {
                        Text("\(episode.episodeNumber)m")
                    }
                    Text("•")
                    Text(episode.overview)
                        .lineLimit(1)
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
                
                // Progress Bar (if applicable) or spacer
                if let progress = progress, progress > 0 {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.3))
                            Capsule().fill(Color.white).frame(width: geo.size.width * progress)
                        }
                    }
                    .frame(height: 4)
                    .padding(.top, 4)
                }
            }
            .padding(12)
            .padding(.bottom, 6) // Lift up from absolute bottom
        }
        .frame(width: 250, height: 250)
        .cornerRadius(12)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(isHovered ? 1.0 : 0.0), lineWidth: 2)
        )
    }
}

