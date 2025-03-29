import CoreLocation

protocol LocationManagerProtocol {
    var zipcode: String? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
}
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, LocationManagerProtocol {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var zipcode: String? = nil
    var zipcodeChanged: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
        self.zipcode = UserDefaults.standard.string(forKey: "lastKnownZipcode")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, let zip = placemark.postalCode {
                if self.zipcode != zip {
                    self.zipcodeChanged = true
                    UserDefaults.standard.setValue(zip, forKey: "lastKnownZipcode")
                }
                self.zipcode = zip
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
}
