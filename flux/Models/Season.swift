import Foundation

struct Season: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let overview: String?
    let posterURL: URL?
    let seasonNumber: Int
    let episodeCount: Int
    var episodes: [Episode]?
}
