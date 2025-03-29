import XCTest
import SwiftUI
import ViewInspector
@testable import Petfinder

final class LabeledInfoTests: XCTestCase {

    func testLabeledInfoLabelAndValueExist() throws {
        let view = LabeledInfo(label: "Breed", value: "Domestic Short Hair")
        let hStack = try view.inspect().hStack()

        let labelText = try hStack.text(0)
        XCTAssertEqual(try labelText.string(), "Breed:")
        XCTAssertEqual(try labelText.attributes().font().weight(), .semibold)
        XCTAssertEqual(try labelText.attributes().foregroundColor(), .secondary)

        let valueText = try hStack.text(1)
        XCTAssertEqual(try valueText.string(), "Domestic Short Hair")
        
        let multilineModifier = try valueText.modifier(_EnvironmentKeyWritingModifier<TextAlignment>.self)
        XCTAssertNotNil(multilineModifier)

        let lineLimit = try valueText.lineLimit()
        XCTAssertEqual(lineLimit, 1)
    }

    func testMultilineLimitIsNil() throws {
        let view = LabeledInfo(label: "Description", value: "A long text", lineLimit: nil)
        let valueText = try view.inspect().hStack().text(1)
        XCTAssertNil(try valueText.lineLimit())
    }
}
