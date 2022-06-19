import CCurl
import Dispatch
import Foundation

public enum CURLError: Error {
    case `internal`(code: Int, str: String)
}

public struct CURLResponse {
    public var statusCode: Int
    public var data: Data
}

public class CURL {
    private var handle: UnsafeMutableRawPointer!

    public var connectTimeout: Int {
        didSet {
            curl_easy_setopt_long(handle, CURLOPT_CONNECTTIMEOUT, connectTimeout)
        }
    }

    public var resourceTimeout: Int {
        didSet {
            curl_easy_setopt_long(handle, CURLOPT_TIMEOUT, resourceTimeout)
        }
    }

    public init(
        method: String,
        url: String,
        connectTimeout: Int = 300,
        resourceTimeout: Int = 0,
        verifyPeer: Bool = true,
        verifyHost: Bool = true,
        verbose: Bool = false
    ) {
        handle = curl_easy_init()
        self.connectTimeout = connectTimeout
        self.resourceTimeout = resourceTimeout

        curl_easy_setopt_string(handle, CURLOPT_URL, url)
        curl_easy_setopt_string(handle, CURLOPT_CUSTOMREQUEST, method)
        curl_easy_setopt_bool(handle, CURLOPT_SSL_VERIFYPEER, verifyPeer)
        curl_easy_setopt_bool(handle, CURLOPT_SSL_VERIFYHOST, verifyHost)
        curl_easy_setopt_bool(handle, CURLOPT_VERBOSE, verbose)
        curl_easy_setopt_long(handle, CURLOPT_NOSIGNAL, 1)

        curl_easy_setopt_write_func(handle, CURLOPT_WRITEFUNCTION, _curl_helper_write_callback)
    }

    public func perform() throws -> CURLResponse {
        var chunk = _curl_helper_memory_struct()
        chunk.memory = malloc(1)
        chunk.size = 0

        defer {
            free(chunk.memory)
        }

        try throwIfError(
            from: withUnsafeMutablePointer(to: &chunk) { pointer in
                curl_easy_setopt_write_data(
                    handle,
                    CURLOPT_WRITEDATA,
                    pointer
                )
            }
        )

        try throwIfError(from: curl_easy_perform(handle))
        var statusCode: Int = -1
        try throwIfError(
            from: withUnsafeMutablePointer(to: &statusCode) { pointer in
                curl_easy_getinfo_long(
                    handle,
                    CURLINFO_RESPONSE_CODE,
                    pointer
                )
            }
        )
        let data = Data(bytes: chunk.memory, count: chunk.size)

        return CURLResponse.init(statusCode: statusCode, data: data)
    }

    private func throwIfError(from code: CURLcode) throws {
        guard code != CURLE_OK else {
            return
        }

        throw CURLError.internal(
            code: Int(code.rawValue),
            str: String(cString: curl_easy_strerror(code), encoding: .ascii) ?? "unknown"
        )
    }

    deinit {
        curl_easy_cleanup(handle)
    }
}
