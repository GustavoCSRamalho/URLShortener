import Foundation

struct ShortenURLResponse: Decodable {
    let alias: String
    let links: Links
    
    struct Links: Decodable {
        let selfLink: String
        let short: String
        
        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
            case short
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case alias
        case links = "_links"
    }
}

struct ShortenURLRequest: Encodable {
    let url: String
}

extension ShortenURLResponse {
    func toDomain() -> ShortenedURL {
        ShortenedURL(
            originalURL: links.selfLink,
            shortURL: links.short,
            alias: alias
        )
    }
}
