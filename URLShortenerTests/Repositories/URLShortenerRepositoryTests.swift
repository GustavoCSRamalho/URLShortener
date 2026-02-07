import XCTest
@testable import URLShortener

final class URLShortenerRepositoryTests: XCTestCase {
    var sut: URLShortenerRepositoryImpl!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = URLShortenerRepositoryImpl(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testShortenURL_Success() async throws {
        let testURL = "https://www.apple.com"
        let expectedResponse = ShortenURLResponse(
            alias: "abc123",
            links: ShortenURLResponse.Links(
                selfLink: testURL,
                short: "https://short.url/abc123"
            )
        )
        mockNetworkService.mockResponse = expectedResponse
        
        let result = try await sut.shortenURL(testURL)
        
        XCTAssertEqual(result.alias, "abc123")
        XCTAssertEqual(result.originalURL, testURL)
        XCTAssertEqual(result.shortURL, "https://short.url/abc123")
    }
    
    func testShortenURL_NetworkError() async {
        let testURL = "https://www.apple.com"
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = URLShortenerError.networkError("Network failure")
        
        do {
            _ = try await sut.shortenURL(testURL)
            XCTFail("Should throw network error")
        } catch let error as URLShortenerError {
            if case .networkError(let message) = error {
                XCTAssertEqual(message, "Network failure")
            } else {
                XCTFail("Wrong error type")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testShortenURL_DecodingError() async {
        let testURL = "https://www.apple.com"
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = URLShortenerError.decodingError
        
        do {
            _ = try await sut.shortenURL(testURL)
            XCTFail("Should throw decoding error")
        } catch let error as URLShortenerError {
            XCTAssertEqual(error, URLShortenerError.decodingError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}

final class MockNetworkService: NetworkServiceProtocol {
    var mockResponse: Any?
    var shouldThrowError = false
    var errorToThrow: Error?
    
    func request<T: Decodable>(endpoint: Endpoint, body: Encodable?) async throws -> T {
        if shouldThrowError {
            throw errorToThrow ?? URLShortenerError.unknown
        }
        
        guard let response = mockResponse as? T else {
            throw URLShortenerError.decodingError
        }
        
        return response
    }
}
