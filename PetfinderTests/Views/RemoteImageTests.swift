import XCTest
import SwiftUI
import ViewInspector
@testable import Petfinder

final class RemoteImageTests: XCTestCase {

    func testDisplaysPlaceholderWhenNoImage() throws {
        let view = RemoteImage(image: nil, type: .dog)
        let rendered = try view.inspect().image()

        XCTAssertEqual(try rendered.actualImage().name(), "dog")
    }

    func testDisplaysProvidedImage() throws {
        let sampleImage = Image(systemName: "star")
        let view = RemoteImage(image: sampleImage, type: .cat)
        let rendered = try view.inspect().image()

        XCTAssertEqual(try rendered.actualImage().name(), "star")
    }
}
