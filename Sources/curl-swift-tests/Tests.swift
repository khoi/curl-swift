import CCurl
import XCTest

@testable import curl_swift

class Tests: XCTestCase {
    let share = CURLSH()
    
    func test_StatusCode() throws {
        let req = CURL(
            method: "GET",
            url: "https://httpbin.org/status/401"
        )
        
        let res = try share.perform(curl: req)

        XCTAssertEqual(res.statusCode, 401)
        XCTAssertEqual(res.body.count, 0)
    }

    func test_Response_Headers() throws {
        let req = CURL(
            method: "GET",
            url:
                "https://httpbin.org/response-headers?non-cf=reprehenderit%20cillum%20ad%20ut&esse84=cillum%20qu&irure409=in%20sed%20Ut&esse84=aaa,b%3Ba%3D2"
        )

        let res = try share.perform(curl: req)

        XCTAssertEqual(res.statusCode, 200)
        XCTAssertEqual(
            res.headers[1...],
            [
                HTTPHeader("content-type", "application/json"),
                HTTPHeader("content-length", "194"),
                HTTPHeader("server", "gunicorn/19.9.0"),
                HTTPHeader("non-cf", "reprehenderit cillum ad ut"),
                HTTPHeader("esse84", "cillum qu"),
                HTTPHeader("esse84", "aaa,b;a=2"),
                HTTPHeader("irure409", "in sed Ut"),
                HTTPHeader("access-control-allow-origin", "*"),
                HTTPHeader("access-control-allow-credentials", "true"),
            ]
        )
    }

    func test_Request_Headers() throws {
        let sendingHeaders = [
            HTTPHeader("Non-Cf", "reprehenderit cillum ad ut"),
            HTTPHeader("Esse84", "cillum qu"),
            HTTPHeader("Esse85", "aaa,b;a=2"),
            HTTPHeader("Irure409", "in sed Ut"),
        ]
        let req = CURL(
            method: "GET",
            url:
                "https://httpbin.org/get",
            headers: sendingHeaders
        )

        let res = try share.perform(curl: req)

        XCTAssertEqual(res.statusCode, 200)

        let jsonObject = try JSONSerialization.jsonObject(with: res.body) as! [String: Any]
        let responseHeaders = jsonObject["headers"] as! [String: String]

        sendingHeaders.forEach {
            XCTAssertEqual(responseHeaders[$0.name], $0.value)
        }
    }

    func test_FollowRedirect_SetToFalse() throws {
        let req = CURL(
            method: "GET",
            url: "http://httpbin.org/absolute-redirect/1"
        )

        req.followRedirection = false

        let res = try share.perform(curl: req)

        XCTAssertEqual(res.statusCode, 302)
        XCTAssertEqual(res.effectiveURL, "http://httpbin.org/absolute-redirect/1")
    }

    func test_FollowRedirect_SetToTrue() throws {
        let req = CURL(
            method: "GET",
            url: "http://httpbin.org/absolute-redirect/1"
        )

        req.followRedirection = true

        let res = try share.perform(curl: req)

        XCTAssertEqual(res.statusCode, 200)
        XCTAssertEqual(res.effectiveURL, "http://httpbin.org/get")
    }

    func test_TotalResponseTime() throws {
        let req = CURL(
            method: "GET",
            url:
                "https://httpbin.org/get"
        )

        let res = try share.perform(curl: req)

        XCTAssertTrue(res.totalResponseTime > 100)
    }

    func test_TotalSizeDowload() throws {
        let req = CURL(
            method: "GET",
            url:
                "https://httpbin.org/get"
        )

        let res = try share.perform(curl: req)

        XCTAssertTrue(res.totalSizeDownload > 100)
    }
}
