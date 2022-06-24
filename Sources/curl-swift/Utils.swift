import Foundation
import CCurl

func callCCurlAndThrowCURLError(block: () -> CURLcode) throws {
    let code = block()
    guard code != CURLE_OK else {
        return
    }

    throw CurlError.internal(
        code: Int(code.rawValue),
        str: String(cString: curl_easy_strerror(code), encoding: .ascii) ?? "unknown"
    )
}
