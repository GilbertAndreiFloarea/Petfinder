import XCTest
import SwiftUI
import ViewInspector
@testable import Petfinder

final class RemoteImageTests: XCTestCase {
    
    func testDisplaysPlaceholderForAllTypes() throws {
        let typesAndExpectedNames: [(Petfinder.PetType, String)] = [
            (.cat, "cat"),
            (.dog, "dog"),
            (.rabbit, "hare"),
            (.bird, "bird"),
            (.unknown, "camera.metering.unknown")
        ]

        for (type, expectedName) in typesAndExpectedNames {
            let view = RemoteImage(image: nil, type: type)
            let inspected = try view.inspect().find(ViewType.Image.self)
            XCTAssertEqual(try inspected.actualImage().name(), expectedName, "Failed for type: \(type)")
        }
    }
    
    func testDisplaysProvidedImage() throws {
        let sampleImage = Image(systemName: "star")
        let view = RemoteImage(image: sampleImage, type: .cat)
        // because it uses an if directly inside body, SwiftUI wraps the result in a TupleView
        let renderedImage = try view.inspect().find(ViewType.Image.self)
        
        XCTAssertEqual(try renderedImage.actualImage().name(), "star")
    }
}
