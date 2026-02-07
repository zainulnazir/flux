import SwiftUI

struct Genre: Identifiable, Hashable {
    let id: Int
    let name: String
    var imageURL: String? // Unsplash URL
    var representativeImageURL: URL?
    
    static let allGenres: [Genre] = [
        Genre(id: 28, name: "Action", imageURL: "https://unsplash.com/photos/r1SwcagHVG0/download?force=true"),
        Genre(id: 12, name: "Adventure", imageURL: "https://unsplash.com/photos/HVWVERp33tQ/download?force=true"),
        Genre(id: 878, name: "Sci-Fi", imageURL: "https://unsplash.com/photos/RgkpHQtcrAE/download?force=true"),
        Genre(id: 35, name: "Comedy", imageURL: "https://unsplash.com/photos/ohbfKsIEbJQ/download?force=true"),
        Genre(id: 18, name: "Drama", imageURL: "https://unsplash.com/photos/65UK3Fa_yIg/download?force=true"),
        Genre(id: 53, name: "Thriller", imageURL: "https://unsplash.com/photos/wmTmcpeHzrI/download?force=true"),
        Genre(id: 27, name: "Horror", imageURL: "https://unsplash.com/photos/uFUQ55RuMrs/download?force=true"),
        Genre(id: 10749, name: "Romance", imageURL: "https://unsplash.com/photos/w5hhoYM_JsU/download?force=true"),
        Genre(id: 14, name: "Fantasy", imageURL: "https://unsplash.com/photos/facU72FcKBI/download?force=true"),
        Genre(id: 16, name: "Animation", imageURL: "https://unsplash.com/photos/JINPheIkUek/download?force=true"),
        Genre(id: 80, name: "Crime", imageURL: "https://unsplash.com/photos/W1J8mMlkmXY/download?force=true"),
        Genre(id: 99, name: "Documentary", imageURL: "https://unsplash.com/photos/9EW7VkfJkSg/download?force=true")
    ]
}

struct GenreCard: View {
    let genre: Genre
    @State private var isHovering = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            CachedImage(url: URL(string: genre.imageURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 240) // Portrait size
                        .clipped()
                default:
                    Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 160, height: 240)
                    .overlay(
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.3))
                    )
                }
            }
            
            // Gradient Overlay
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            
            // Title
            Text(genre.name)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                .padding(.bottom, 20)
        }
        .frame(width: 160, height: 240)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.4), .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        // .scaleEffect(isHovering ? 1.05 : 1.0) // Scaling removed per user request
        .shadow(color: isHovering ? .black.opacity(0.4) : .black.opacity(0.2), radius: isHovering ? 12 : 8, x: 0, y: isHovering ? 6 : 4)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
