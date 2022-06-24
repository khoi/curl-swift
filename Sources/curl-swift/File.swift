import Foundation

public enum CurlError: Error {
    case `internal`(code: Int, str: String)
}
