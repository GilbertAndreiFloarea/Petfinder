
import XCTest
import SwiftUI
import ViewInspector
@testable import Petfinder

final class EmptyStateTests: XCTestCase {

    func testEmptyStateDisplaysCorrectImageAndMessage() throws {
        let view = EmptyState(imageName: "test-image", message: "Test message here")

        let inspectedImage = try view.inspect().find(ViewType.Image.self)
        XCTAssertEqual(try inspectedImage.actualImage().name(), "test-image")

        let inspectedText = try view.inspect().find(ViewType.Text.self)
        XCTAssertEqual(try inspectedText.string(), "Test message here")
    }
}
