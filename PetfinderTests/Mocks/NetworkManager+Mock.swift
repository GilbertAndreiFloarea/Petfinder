import XCTest
@testable import Petfinder

class MockNetworkManager: NetworkManagerProtocol {
    var nextPageURL: String?
    var fetchPetsCalled: Bool = false
    var shouldThrowError: Bool = false
    private let cache = NSCache<NSString, UIImage>()
    
    func fetchPets(from url: String?, currentZipCode: String?) async throws -> Petfinder.PetResponse {
        fetchPetsCalled = true
        if shouldThrowError {
            throw PError.unableToComplete
        }
        let json = """
        {
            "animals": [],
            "pagination": {
                "current_page": 1,
                "count_per_page": 20,
                "total_pages": 1,
                "total_count": 0,
                "_links": {
                    "next": null
                }
            }
        }
        """.data(using: .utf8)!
        let response = try JSONDecoder().decode(Petfinder.PetResponse.self, from: json)
        return response
    }
    
    func loadNextPageIfNeeded() async throws -> Petfinder.PetResponse? {
        guard let nextURL = nextPageURL else {
            throw PError.invalidURL
        }

        do {
            return try await fetchPets(from: "https://api.petfinder.com" + nextURL, currentZipCode: nil)
        } catch {
            print("❌ Mock Error fetching next page: \(error)")
            throw PError.unableToComplete
        }
    }
    
    func downloadImage(fromURLString urlString: String) async throws -> UIImage? {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            return image
        }

        guard let url = URL(string: urlString),
              let data = URLProtocolMock.testURLs[url],
              let image = UIImage(data: data) else {
            return nil
        }

        cache.setObject(image, forKey: cacheKey)
        return image
    }
}
