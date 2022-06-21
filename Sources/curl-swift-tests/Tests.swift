import CCurl
import XCTest

@testable import curl_swift

class Tests: XCTestCase {
    func test_StatusCode() throws {
        let req = CURL(
            method: "GET",
            url: "https://httpbin.org/status/401"
        )

        let res = try req.perform()

        XCTAssertEqual(res.statusCode, 401)
        XCTAssertEqual(res.body.count, 0)
    }

    func test_Headers() throws {
        let req = CURL(
            method: "GET",
            url:
                "https://httpbin.org/response-headers?non_cf=reprehenderit%20cillum%20ad%20ut&esse84=cillum%20qu&irure409=in%20sed%20Ut&esse84=aaa,b%3Ba%3D2"
        )

        let res = try req.perform()

        XCTAssertEqual(res.statusCode, 200)
        XCTAssertEqual(
            res.headers[1...],
            [
                HTTPHeader("content-type", "application/json"),
                HTTPHeader("content-length", "194"),
                HTTPHeader("server", "gunicorn/19.9.0"),
                HTTPHeader("non_cf", "reprehenderit cillum ad ut"),
                HTTPHeader("esse84", "cillum qu"),
                HTTPHeader("esse84", "aaa,b;a=2"),
                HTTPHeader("irure409", "in sed Ut"),
                HTTPHeader("access-control-allow-origin", "*"),
                HTTPHeader("access-control-allow-credentials", "true"),
            ]
        )
    }
}
