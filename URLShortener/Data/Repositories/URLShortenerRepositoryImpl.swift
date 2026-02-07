import Foundation

final class URLShortenerRepositoryImpl: URLShortenerRepository {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func shortenURL(_ url: String) async throws -> ShortenedURL {
        let requestBody = ShortenURLRequest(url: url)
        
        let response: ShortenURLResponse = try await networkService.request(
            endpoint: .shortenURL,
            body: requestBody
        )
        
        return response.toDomain()
    }
}
