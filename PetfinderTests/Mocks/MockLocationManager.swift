import CoreLocation
import XCTest
@testable import Petfinder

final class MockLocationManager: LocationManagerProtocol {
    var authorizationStatus: CLAuthorizationStatus {
        return .authorizedWhenInUse
    }
    
    var zipcode: String? {
        return "12345"
    }
}
