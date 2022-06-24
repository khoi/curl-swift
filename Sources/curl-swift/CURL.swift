import CCurl
import Foundation

public struct Response {
    public let statusCode: Int
    public let body: Data
    public let headers: [HTTPHeader]
    public let effectiveURL: String
    public let totalResponseTime: Int
    public let totalSizeDownload: Int
}

public class CURL {
    public enum Error: Swift.Error {
        case `internal`(code: Int, str: String)
    }

    private var handle: UnsafeMutableRawPointer!
    public var headers: [HTTPHeader]

    public var connectTimeout: Int = 300 {
        didSet {
            curl_easy_setopt_long(handle, CURLOPT_CONNECTTIMEOUT, connectTimeout)
        }
    }

    public var resourceTimeout: Int = 0 {
        didSet {
            curl_easy_setopt_long(handle, CURLOPT_TIMEOUT, resourceTimeout)
        }
    }

    public var followRedirection: Bool = false {
        didSet {
            curl_easy_setopt_long(handle, CURLOPT_FOLLOWLOCATION, followRedirection ? 1 : 0)
        }
    }

    public var verifyPeer: Bool = false {
        didSet {
            curl_easy_setopt_bool(handle, CURLOPT_SSL_VERIFYPEER, verifyPeer)
        }
    }

    public var verifyHost: Bool = false {
        didSet {
            curl_easy_setopt_bool(handle, CURLOPT_SSL_VERIFYHOST, verifyHost)
        }
    }

    public init(
        method: String,
        url: String,
        headers: [HTTPHeader] = [],
        verbose: Bool = false
    ) {
        handle = curl_easy_init()
        self.headers = headers

        curl_easy_setopt_string(handle, CURLOPT_URL, url)
        curl_easy_setopt_string(handle, CURLOPT_CUSTOMREQUEST, method)
        curl_easy_setopt_bool(handle, CURLOPT_SSL_VERIFYPEER, verifyPeer)
        curl_easy_setopt_bool(handle, CURLOPT_SSL_VERIFYHOST, verifyHost)
        curl_easy_setopt_bool(handle, CURLOPT_VERBOSE, verbose)
        curl_easy_setopt_long(handle, CURLOPT_NOSIGNAL, 1)

        curl_easy_setopt_write_func(handle, CURLOPT_WRITEFUNCTION, curl_write_callback_fn)
        curl_easy_setopt_write_func(handle, CURLOPT_HEADERFUNCTION, curl_write_callback_fn)
    }

    public func perform() throws -> Response {
        var headerChunk: UnsafeMutablePointer<curl_slist>! = nil
        if headers.count > 0 {
            headers.forEach {
                headerChunk = curl_slist_append(headerChunk, $0.description)
            }
            curl_easy_setopt_ptr_slist(handle, CURLOPT_HTTPHEADER, headerChunk)

        }
        defer { curl_slist_free_all(headerChunk) }

        var body = curl_memory_struct(ptr: malloc(1), size: 0)
        defer { free(body.ptr) }

        try callCCurl {
            withUnsafeMutablePointer(to: &body) { pointer in
                curl_easy_setopt_write_data(
                    handle,
                    CURLOPT_WRITEDATA,
                    pointer
                )
            }
        }

        var header = curl_memory_struct(ptr: malloc(1), size: 0)
        defer { free(header.ptr) }

        try callCCurl {
            withUnsafeMutablePointer(to: &header) { pointer in
                curl_easy_setopt_write_data(
                    handle,
                    CURLOPT_HEADERDATA,
                    pointer
                )
            }
        }

        try callCCurl {
            curl_easy_perform(handle)
        }

        return Response(
            statusCode: try get(info: CURLINFO_RESPONSE_CODE),
            body: Data(bytes: body.ptr, count: body.size),
            headers: parseHeaderData(data: Data(bytes: header.ptr, count: header.size)),
            effectiveURL: try get(info: CURLINFO_EFFECTIVE_URL),
            totalResponseTime: try get(info: CURLINFO_TOTAL_TIME_T),
            totalSizeDownload: try get(info: CURLINFO_SIZE_DOWNLOAD_T)
        )
    }

    private func callCCurl(block: () -> CURLcode) throws {
        let code = block()
        guard code != CURLE_OK else {
            return
        }

        throw Self.Error.internal(
            code: Int(code.rawValue),
            str: String(cString: curl_easy_strerror(code), encoding: .ascii) ?? "unknown"
        )
    }

    private func get(info: CURLINFO) throws -> String {
        var stringPointer: UnsafePointer<CChar>? = nil

        try callCCurl {
            curl_easy_getinfo_string(
                handle,
                info,
                &stringPointer
            )
        }

        guard let stringPointer = stringPointer else {
            return ""
        }

        return String(validatingUTF8: stringPointer) ?? ""
    }

    private func get(info: CURLINFO) throws -> Int {
        var value: Int = -1

        try callCCurl {
            withUnsafeMutablePointer(to: &value) { pointer in
                curl_easy_getinfo_long(
                    handle,
                    info,
                    pointer
                )
            }
        }

        return value
    }

    deinit {
        curl_easy_cleanup(handle)
    }
}

private func parseHeaderData(data: Data) -> [HTTPHeader] {
    guard let headerString = String(data: data, encoding: .utf8) else {
        return []
    }

    return headerString.split(whereSeparator: \.isNewline)
        .compactMap { line -> HTTPHeader? in
            let values = line.split(separator: ":")

            guard values.count > 1 else {
                return nil
            }

            let name = String(values[0]).trimmingCharacters(in: CharacterSet.whitespaces)
            let value = values[1..<values.count].joined()
                .trimmingCharacters(in: CharacterSet.whitespaces)

            return HTTPHeader(name, value)
        }
}
