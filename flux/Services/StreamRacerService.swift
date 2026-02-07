import Foundation

struct RacingResult: Codable {
    let url: String
    let latency: Int
    let status: Int
}

struct RacingRequest: Codable {
    let urls: [String]
}

class StreamRacerService {
    static let shared = StreamRacerService()
    
    private init() {}
    
    func race(workerURL: URL, streamURLs: [URL]) async throws -> URL? {
        // Convert URLs to strings
        let urlStrings = streamURLs.map { $0.absoluteString }
        
        let requestBody = RacingRequest(urls: urlStrings)
        
        var request = URLRequest(url: workerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)
        request.timeoutInterval = 5 // Fail fast if racer is stuck
        
        print("[StreamRacer] Racing \(urlStrings.count) streams via \(workerURL)...")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("[StreamRacer] Worker returned non-200 status.")
            return nil
        }
        
        let result = try JSONDecoder().decode(RacingResult.self, from: data)
        print("[StreamRacer] Winner: \(result.url) (\(result.latency)ms)")
        
        return URL(string: result.url)
    }
}
