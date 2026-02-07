import Foundation

enum Endpoint {
    case shortenURL
    case getURL(alias: String)
    
    private var baseURL: String {
        "https://url-shortener-server.onrender.com/api"
    }
    
    private var path: String {
        switch self {
        case .shortenURL:
            return "/alias"
        case .getURL(let alias):
            return "/alias/\(alias)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .shortenURL:
            return .post
        case .getURL:
            return .get
        }
    }
    
    var url: URL? {
        URL(string: baseURL + path)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
