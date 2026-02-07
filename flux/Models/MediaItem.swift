import Foundation

struct CastMember: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let role: String
    let imageURL: URL?
}

struct MediaItem: Identifiable, Hashable, Codable {
    var id: String {
        "\(category)-\(tmdbID ?? 0)"
    }
    let tmdbID: Int?
    let title: String
    let description: String
    let imageURL: URL? // Fallback/Main image
    var posterURL: URL?
    var backdropURL: URL?
    var heroURL: URL?
    let streamURL: URL?
    let category: String
    var progress: Double? // 0.0 to 1.0
    var trailerURL: URL?
    var cast: [CastMember]?
    
    // New Fields for Phase 17
    var seasons: [Season]?
    var runtime: String? // e.g. "2h 14m" or "45m"
    var certification: String? // e.g. "PG-13", "TV-MA"
    var genres: [String]?
    var popularity: Double? // For search ranking
    var releaseDate: String? // YYYY-MM-DD
    var spokenLanguages: [String]? // e.g. ["English", "Spanish"]
    var originCountry: String? // e.g. "United States"
    var voteAverage: Double? // e.g. 7.8
    
    var releaseDateYear: String? {
        guard let date = releaseDate else { return nil }
        return String(date.prefix(4))
    }
    
    // History Specific
    var lastSeason: Int?
    var lastEpisode: Int?
    var lastEpisodeTitle: String?
    var lastEpisodeImage: URL?
}
