import XCTest
import SwiftUI
@testable import Petfinder

final class AlertItemTests: XCTestCase {
    
    func testAlertItemInitialization() {
        let title = Text("Test Title")
        let message = Text("Test Message")
        let button = Alert.Button.default(Text("OK"))

        let alert = AlertItem(title: title, message: message, dismissButton: button)

        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.message, message)
    }
}
