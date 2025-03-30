import Foundation
import Combine

private struct TokenResponse: Decodable {
    let access_token: String
    let expires_in: Int
}

class AuthService {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    private let apiSecret = Bundle.main.object(forInfoDictionaryKey: "API_SECRET") as? String ?? ""
    private let apiHOST = Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String ?? ""
    
    private var tokenURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = apiHOST
        components.path = "/v2/oauth2/token"
        return components.url!
    }
    
    private var accessToken: String?
    private var tokenExpirationDate: Date?
    
    func fetchAccessTokenAsync() async throws -> String {
        if let token = accessToken, let expiration = tokenExpirationDate, Date() < expiration {
            return token
        }
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = "grant_type=client_credentials&client_id=\(apiKey)&client_secret=\(apiSecret)"
        request.httpBody = bodyParams.data(using: .utf8)
        
        var lastError: Error?
        
        for _ in 1...3 {
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
                
                accessToken = decoded.access_token
                tokenExpirationDate = Date().addingTimeInterval(TimeInterval(decoded.expires_in))
                
                return decoded.access_token
            } catch {
                lastError = error
            }
        }
        
        throw lastError ?? URLError(.badServerResponse)
    }
}
