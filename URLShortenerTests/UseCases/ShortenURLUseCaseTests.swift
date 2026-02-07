import XCTest
@testable import URLShortener

final class ShortenURLUseCaseTests: XCTestCase {
    
    var sut: ShortenURLUseCase!
    var mockRepository: MockURLShortenerRepository!
    var validator: URLValidator!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockURLShortenerRepository()
        validator = URLValidator()
        sut = ShortenURLUseCase(repository: mockRepository, validator: validator)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        validator = nil
        super.tearDown()
    }
    
    func testExecute_ValidURL_Success() async throws {
        let validURL = "https://www.apple.com"
        let expectedResult = ShortenedURL(
            originalURL: validURL,
            shortURL: "https://short.url/abc123",
            alias: "abc123"
        )
        mockRepository.mockResult = expectedResult
        
        let result = try await sut.execute(url: validURL)
        
        XCTAssertEqual(result.originalURL, validURL)
        XCTAssertEqual(result.alias, "abc123")
        XCTAssertTrue(mockRepository.shortenURLCalled)
    }
    
    func testExecute_URLWithoutScheme_NormalizesAndSucceeds() async throws {
        let urlWithoutScheme = "www.apple.com"
        let expectedResult = ShortenedURL(
            originalURL: "https://www.apple.com",
            shortURL: "https://short.url/abc123",
            alias: "abc123"
        )
        mockRepository.mockResult = expectedResult
        
        let result = try await sut.execute(url: urlWithoutScheme)
        
        XCTAssertEqual(result.originalURL, "https://www.apple.com")
        XCTAssertTrue(mockRepository.shortenURLCalled)
    }
    
    func testExecute_InvalidURL_ThrowsError() async {
        let invalidURL = "not a valid url"
        
        do {
            _ = try await sut.execute(url: invalidURL)
            XCTFail("Should throw invalid URL error")
        } catch let error as URLShortenerError {
            XCTAssertEqual(error, URLShortenerError.invalidURL)
            XCTAssertFalse(mockRepository.shortenURLCalled)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testExecute_EmptyURL_ThrowsError() async {
        let emptyURL = ""
        
        do {
            _ = try await sut.execute(url: emptyURL)
            XCTFail("Should throw invalid URL error")
        } catch let error as URLShortenerError {
            XCTAssertEqual(error, URLShortenerError.invalidURL)
            XCTAssertFalse(mockRepository.shortenURLCalled)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testExecute_RepositoryError_PropagatesError() async {
        let validURL = "https://www.apple.com"
        mockRepository.shouldThrowError = true
        mockRepository.errorToThrow = URLShortenerError.networkError("Network failed")
        
        do {
            _ = try await sut.execute(url: validURL)
            XCTFail("Should propagate repository error")
        } catch let error as URLShortenerError {
            if case .networkError(let message) = error {
                XCTAssertEqual(message, "Network failed")
            } else {
                XCTFail("Wrong error type")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}

final class MockURLShortenerRepository: URLShortenerRepository {
    var mockResult: ShortenedURL?
    var shouldThrowError = false
    var errorToThrow: Error?
    var shortenURLCalled = false
    
    func shortenURL(_ url: String) async throws -> ShortenedURL {
        shortenURLCalled = true
        
        if shouldThrowError {
            throw errorToThrow ?? URLShortenerError.unknown
        }
        
        guard let result = mockResult else {
            throw URLShortenerError.unknown
        }
        
        return result
    }
}
