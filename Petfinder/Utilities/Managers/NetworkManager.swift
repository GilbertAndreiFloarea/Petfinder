import UIKit
import CoreLocation

protocol NetworkManagerProtocol {
    func downloadImage(fromURLString urlString: String) async throws -> UIImage?
    func fetchPets(from url: String?, currentZipCode: String?) async throws -> PetResponse
    func loadNextPageIfNeeded() async throws -> PetResponse?
}

final class NetworkManager: NetworkManagerProtocol {
    private let apiHOST = Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String ?? ""
    
    static var shared: NetworkManagerProtocol = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    private let authService = AuthService()
    private var token: String = ""
    private var nextPageURL: String? = nil
    private var baseURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = apiHOST
        return components.url!
    }
    private let locationManager = LocationManager()
    private init() {}
    
    func fetchPets(from url: String? = nil, currentZipCode: String? = nil) async throws -> PetResponse {
        do {
            let token = try await authService.fetchAccessTokenAsync()
            self.token = token
        } catch {
            print("❌ Token Error: \(error)")
            throw PError.invalidToken
        }
        
        var request: URLRequest
        
        if let url {
            guard let url = URL(string: url) else {
                throw PError.invalidURL
            }
            request = URLRequest(url: url)
        } else {
            var components = URLComponents(url: baseURL.appendingPathComponent("/v2/animals"), resolvingAgainstBaseURL: false)!
            var queryItems = [
                URLQueryItem(name: "limit", value: "25"),
                URLQueryItem(name: "page", value: "1")
            ]
            
            let status = locationManager.authorizationStatus
            if status == .notDetermined {
                var updatedStatus: CLAuthorizationStatus = .notDetermined
                var attempts = 0
                while updatedStatus == .notDetermined && attempts < 50 {
                    try await Task.sleep(nanoseconds: 250_000_000) // 0.25 second
                    updatedStatus = locationManager.authorizationStatus
                    attempts += 1
                }
            }
            
            let finalStatus = locationManager.authorizationStatus
            var zipcodeToUse = currentZipCode
            
            if zipcodeToUse == nil, finalStatus == .authorizedWhenInUse || finalStatus == .authorizedAlways {
                let maxAttempts = 20
                var attempts = 0
                while locationManager.zipcode == nil && attempts < maxAttempts {
                    try await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
                    attempts += 1
                }
                zipcodeToUse = locationManager.zipcode
            }
            
            if let zipcode = zipcodeToUse {
                queryItems.append(URLQueryItem(name: "location", value: zipcode))
            }
            
            components.queryItems = queryItems
            request = URLRequest(url: components.url!)
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("📦 Raw JSON Response:\n\(prettyString)")
        } else {
            print("⚠️ Failed to pretty-print JSON")
        }
        
        do {
            let response = try JSONDecoder().decode(PetResponse.self, from: data)
            self.nextPageURL = response.pagination.links.next?.href
            return response
        } catch {
            throw PError.invalidData
        }
        
    }
    
    func loadNextPageIfNeeded() async throws -> PetResponse? {
        guard let nextURL = nextPageURL else {
            throw PError.invalidURL
        }

        do {
            return try await fetchPets(from: baseURL.absoluteString + nextURL)
        } catch {
            print("❌ Error fetching next page: \(error)")
            throw PError.unableToComplete
        }
    }
    
    func downloadImage(fromURLString urlString: String) async throws -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        self.cache.setObject(image, forKey: cacheKey)
        return image
    }
}
