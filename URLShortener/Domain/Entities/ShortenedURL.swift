import Foundation

struct ShortenedURL: Identifiable, Equatable, Codable {
    let id: String
    let originalURL: String
    let shortURL: String
    let alias: String
    let createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        originalURL: String,
        shortURL: String,
        alias: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.originalURL = originalURL
        self.shortURL = shortURL
        self.alias = alias
        self.createdAt = createdAt
    }
}

extension ShortenedURL {
    static var mock: ShortenedURL {
        ShortenedURL(
            originalURL: "https://www.apple.com",
            shortURL: "https://url-shortener-server.onrender.com/abc123",
            alias: "abc123"
        )
    }
    
    static var mocks: [ShortenedURL] {
        [
            ShortenedURL(
                originalURL: "https://www.apple.com",
                shortURL: "https://url-shortener-server.onrender.com/abc123",
                alias: "abc123"
            ),
            ShortenedURL(
                originalURL: "https://www.github.com",
                shortURL: "https://url-shortener-server.onrender.com/def456",
                alias: "def456"
            ),
            ShortenedURL(
                originalURL: "https://www.stackoverflow.com",
                shortURL: "https://url-shortener-server.onrender.com/ghi789",
                alias: "ghi789"
            )
        ]
    }
}
