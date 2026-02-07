import Foundation

enum URLShortenerError: LocalizedError, Equatable {
    case invalidURL
    case networkError(String)
    case serverError(Int, String)
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida. Por favor, insira uma URL válida."
        case .networkError(let message):
            return "Erro de rede: \(message)"
        case .serverError(let code, let message):
            return "Erro do servidor (\(code)): \(message)"
        case .decodingError:
            return "Erro ao processar resposta do servidor."
        case .unknown:
            return "Erro desconhecido. Tente novamente."
        }
    }
    
    static func == (lhs: URLShortenerError, rhs: URLShortenerError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.decodingError, .decodingError),
             (.unknown, .unknown):
            return true
        case (.networkError(let lhsMsg), .networkError(let rhsMsg)):
            return lhsMsg == rhsMsg
        case (.serverError(let lhsCode, let lhsMsg), .serverError(let rhsCode, let rhsMsg)):
            return lhsCode == rhsCode && lhsMsg == rhsMsg
        default:
            return false
        }
    }
}
