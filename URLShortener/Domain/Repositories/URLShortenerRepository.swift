import Foundation

protocol URLShortenerRepository {
    func shortenURL(_ url: String) async throws -> ShortenedURL
}
