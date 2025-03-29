import XCTest
@testable import Petfinder

// URLProtocol mock to intercept network requests
final class URLProtocolMock: URLProtocol {
    static var testURLs = [URL: Data]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url, let data = URLProtocolMock.testURLs[url] {
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
