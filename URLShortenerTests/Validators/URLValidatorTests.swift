import XCTest
@testable import URLShortener

final class URLValidatorTests: XCTestCase {
    
    var sut: URLValidator!
    
    override func setUp() {
        super.setUp()
        sut = URLValidator()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testValidURL_WithHTTPS() {
        let url = "https://www.apple.com"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertTrue(isValid, "URL with https should be valid")
    }
    
    func testValidURL_WithHTTP() {
        let url = "http://www.apple.com"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertTrue(isValid, "URL with http should be valid")
    }
    
    func testValidURL_WithoutScheme() {
        let url = "www.apple.com"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertTrue(isValid, "URL without scheme should be valid (normalized)")
    }
    
    func testValidURL_WithSubdomain() {
        let url = "https://developer.apple.com"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertTrue(isValid, "URL with subdomain should be valid")
    }
    
    func testValidURL_WithPath() {
        let url = "https://www.apple.com/iphone"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertTrue(isValid, "URL with path should be valid")
    }
    
    func testValidURL_WithQueryParameters() {
        let url = "https://www.google.com/search?q=swift"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertTrue(isValid, "URL with query parameters should be valid")
    }
    
    func testInvalidURL_Empty() {
        let url = ""
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertFalse(isValid, "Empty string should be invalid")
    }
    
    func testInvalidURL_OnlySpaces() {
        let url = "   "
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertFalse(isValid, "Only spaces should be invalid")
    }
    
    func testInvalidURL_NoHost() {
        let url = "https://"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertFalse(isValid, "URL without host should be invalid")
    }
    
    func testInvalidURL_InvalidCharacters() {
        let url = "https://invalid url with spaces.com"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertFalse(isValid, "URL with spaces should be invalid")
    }
    
    func testInvalidURL_NoTLD() {
        let url = "https://localhost"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertFalse(isValid, "URL without TLD should be invalid")
    }
    
    func testInvalidURL_OnlyText() {
        let url = "not a url"
        
        let isValid = sut.isValid(url: url)
        
        XCTAssertFalse(isValid, "Plain text should be invalid")
    }
    
    func testNormalizeURL_AddsHTTPS() {
        let url = "www.apple.com"
        
        let normalized = sut.normalizeURL(url)
        
        XCTAssertEqual(normalized, "https://www.apple.com")
    }
    
    func testNormalizeURL_PreservesHTTPS() {
        let url = "https://www.apple.com"
        
        let normalized = sut.normalizeURL(url)
        
        XCTAssertEqual(normalized, "https://www.apple.com")
    }
    
    func testNormalizeURL_PreservesHTTP() {
        let url = "http://www.apple.com"
        
        let normalized = sut.normalizeURL(url)
        
        XCTAssertEqual(normalized, "http://www.apple.com")
    }
    
    func testNormalizeURL_TrimsWhitespace() {
        let url = "  www.apple.com  "
        
        let normalized = sut.normalizeURL(url)
        
        XCTAssertEqual(normalized, "https://www.apple.com")
    }
}
