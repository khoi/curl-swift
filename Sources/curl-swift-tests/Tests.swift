import CCurl
import XCTest

@testable import curl_swift

class Tests: XCTestCase {
    func test_StatusCode() throws {
        let req = CURL.init(
            method: "GET",
            url: "https://httpbin.org/status/401",
            verifyPeer: false,
            verifyHost: false,
            verbose: true
        )

        let res = try req.perform()

        XCTAssertEqual(res.statusCode, 401)
    }
}
