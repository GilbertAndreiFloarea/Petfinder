import XCTest
import SwiftUI
import ViewInspector
@testable import Petfinder

final class LabeledInfoTests: XCTestCase {

    func testLabeledInfoLabelAndValueExist() throws {
        let view = LabeledInfo(label: "Breed", value: "Domestic Short Hair")
        let hStack = try view.inspect().implicitAnyView().hStack()

        let labelText = try hStack.text(0)
        XCTAssertEqual(try labelText.string(), "Breed:")
        XCTAssertEqual(try labelText.attributes().fontWeight(), .semibold)
        XCTAssertEqual(try labelText.attributes().foregroundColor(), .secondary)

        let valueText = try hStack.text(1)
        XCTAssertEqual(try valueText.string(), "Domestic Short Hair")

        let lineLimit = try valueText.lineLimit()
        XCTAssertEqual(lineLimit, 1)
    }

}
