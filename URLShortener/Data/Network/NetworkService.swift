import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: Endpoint,
        body: Encodable?
    ) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        body: Encodable? = nil
    ) async throws -> T {
        
        guard let url = endpoint.url else {
            throw URLShortenerError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw URLShortenerError.decodingError
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLShortenerError.unknown
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw URLShortenerError.serverError(
                    httpResponse.statusCode,
                    errorMessage
                )
            }
            
            do {
                let decoded = try decoder.decode(T.self, from: data)
                return decoded
            } catch {
                throw URLShortenerError.decodingError
            }
            
        } catch let error as URLShortenerError {
            throw error
        } catch {
            throw URLShortenerError.networkError(error.localizedDescription)
        }
    }
}
