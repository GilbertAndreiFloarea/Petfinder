import XCTest
@testable import Petfinder

final class MockAuthService: AuthService {
    override func fetchAccessTokenAsync() async throws -> String {
        return "mock_token"
    }
}
