import XCTest
import UIKit
@testable import Petfinder

final class NetworkManagerTests: XCTestCase {
    
    func testDownloadImageCachesResult() async throws {
        let urlString = "https://example.com/fakeimage.png"
        let imageData = UIImage(systemName: "star")!.pngData()!
        let url = URL(string: urlString)!
        
        URLProtocolMock.testURLs = [url: imageData]
        URLProtocol.registerClass(URLProtocolMock.self)
        
        let networkManager = MockNetworkManager()
        let result1 = try await networkManager.downloadImage(fromURLString: urlString)
        let result2 = try await networkManager.downloadImage(fromURLString: urlString)
        
        XCTAssertNotNil(result1)
        XCTAssertEqual(result1, result2) // same image object from cache
    }
    
    func testFetchPetsReturnsEmptyList() async throws {
        let response = try await MockNetworkManager().fetchPets(from: nil, currentZipCode: nil)
        
        XCTAssertEqual(response.animals.count, 0)
        XCTAssertEqual(response.pagination.currentPage, 1)
        XCTAssertNil(response.pagination.links.next)
    }
    
    func testLoadNextPageReturnsResponse() async throws {
        let manager = MockNetworkManager()
        manager.nextPageURL = "/v2/animals?page=2"

        let response = try await manager.loadNextPageIfNeeded()
        XCTAssertEqual(response?.pagination.currentPage, 1)
        XCTAssertEqual(response?.pagination.totalPages, 1)
        XCTAssertEqual(response?.pagination.countPerPage, 20)
    }

    func testLoadNextPageThrowsWhenNoNextURL() async {
        let manager = MockNetworkManager()
        manager.nextPageURL = nil

        do {
            _ = try await manager.loadNextPageIfNeeded()
            XCTFail("Expected to throw, but did not.")
        } catch {
            XCTAssertEqual(error as? PError, PError.invalidURL)
        }
    }

    func testLoadNextPageHandlesFetchError() async {
        let manager = MockNetworkManager()
        manager.nextPageURL = "/v2/animals?page=2"
        manager.shouldThrowError = true

        do {
            _ = try await manager.loadNextPageIfNeeded()
            XCTFail("Expected to throw, but did not.")
        } catch {
            XCTAssertEqual(error as? PError, PError.unableToComplete)
        }
    }
}
