import XCTest
@testable import URLShortener

@MainActor
final class URLShortenerViewModelTests: XCTestCase {
    
    var sut: URLShortenerViewModel!
    var mockRepository: MockURLShortenerRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockURLShortenerRepository()
        sut = URLShortenerViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(sut.shortenedURLs.isEmpty)
        XCTAssertEqual(sut.inputURL, "")
        XCTAssertFalse(sut.isInputValid)
    }
    
    func testInputValidation_ValidURL() async {
        sut.inputURL = "https://www.apple.com"
        sut.validateInput()
        
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        XCTAssertTrue(sut.isInputValid)
    }
    
    func testInputValidation_InvalidURL() async {
        sut.inputURL = "invalid url"
        sut.validateInput()
        
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        XCTAssertFalse(sut.isInputValid)
    }
    
    func testInputValidation_EmptyURL() async {
        sut.inputURL = ""
        sut.validateInput()
        
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        XCTAssertFalse(sut.isInputValid)
    }
    
    func testShortenURL_Success() async {
        let testURL = "https://www.apple.com"
        let expectedResult = ShortenedURL(
            originalURL: testURL,
            shortURL: "https://short.url/abc123",
            alias: "abc123"
        )
        mockRepository.mockResult = expectedResult
        sut.inputURL = testURL
        
        sut.shortenURL()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.shortenedURLs.count, 1)
        XCTAssertEqual(sut.shortenedURLs.first?.alias, "abc123")
        XCTAssertEqual(sut.inputURL, "")
    }
    
    func testShortenURL_InvalidURL_ShowsError() async {
        sut.inputURL = "invalid"
        mockRepository.shouldThrowError = true
        mockRepository.errorToThrow = URLShortenerError.invalidURL
        
        sut.shortenURL()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if case .error(let message) = sut.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Should be in error state")
        }
    }
    
    func testShortenURL_NetworkError_ShowsError() async {
        let testURL = "https://www.apple.com"
        sut.inputURL = testURL
        mockRepository.shouldThrowError = true
        mockRepository.errorToThrow = URLShortenerError.networkError("Connection failed")
        
        sut.shortenURL()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if case .error(let message) = sut.state {
            XCTAssertTrue(message.contains("Connection failed"))
        } else {
            XCTFail("Should be in error state")
        }
    }
    
    func testShortenURL_EmptyInput_DoesNothing() {
        sut.inputURL = ""
        
        sut.shortenURL()
        
        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(sut.shortenedURLs.isEmpty)
    }
    
    func testRemoveURL() async {
        let url1 = ShortenedURL(
            originalURL: "https://apple.com",
            shortURL: "https://short.url/abc",
            alias: "abc"
        )
        let url2 = ShortenedURL(
            originalURL: "https://google.com",
            shortURL: "https://short.url/def",
            alias: "def"
        )
        
        mockRepository.mockResult = url1
        sut.inputURL = "https://apple.com"
        sut.shortenURL()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        mockRepository.mockResult = url2
        sut.inputURL = "https://google.com"
        sut.shortenURL()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(sut.shortenedURLs.count, 2)
        
        sut.removeURL(at: IndexSet(integer: 0))
        
        XCTAssertEqual(sut.shortenedURLs.count, 1)
        XCTAssertEqual(sut.shortenedURLs.first?.alias, "abc")
    }
}
