import XCTest

final class URLShortenerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testInitialState() {
        XCTAssertTrue(app.navigationBars["URL Shortener"].exists)
        XCTAssertTrue(app.textFields["urlInput"].exists)
        XCTAssertTrue(app.buttons["shortenButton"].exists)
    }
    
    func testInputField_AcceptsText() {
        let textField = app.textFields["urlInput"]
        
        textField.tap()
        textField.typeText("https://www.apple.com")
        
        XCTAssertEqual(textField.value as? String, "https://www.apple.com")
    }
    
    func testShortenButton_InitiallyDisabled() {
        let button = app.buttons["shortenButton"]
        
        XCTAssertFalse(button.isEnabled)
    }
    
    func testShortenButton_EnabledWithValidURL() {
        let textField = app.textFields["urlInput"]
        let button = app.buttons["shortenButton"]
        
        textField.tap()
        textField.typeText("https://www.apple.com")
        
        sleep(1)
        
        XCTAssertTrue(button.isEnabled)
    }
    
    func testEmptyState_DisplayedInitially() {
        XCTAssertTrue(app.staticTexts["Nenhuma URL encurtada ainda"].exists)
    }
    
    func testLaunchPerformance() {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
