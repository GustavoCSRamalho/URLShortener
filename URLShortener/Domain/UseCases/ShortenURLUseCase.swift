import Foundation

final class ShortenURLUseCase {
    
    private let repository: URLShortenerRepository
    private let validator: URLValidator
    
    init(
        repository: URLShortenerRepository,
        validator: URLValidator
    ) {
        self.repository = repository
        self.validator = validator
    }
    
    func execute(url: String) async throws -> ShortenedURL {
        guard validator.isValid(url: url) else {
            throw URLShortenerError.invalidURL
        }
        let normalizedURL = validator.normalizeURL(url)
        
        return try await repository.shortenURL(normalizedURL)
    }
}
