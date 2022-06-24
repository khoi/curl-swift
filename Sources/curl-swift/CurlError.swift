import Foundation

public enum CURLError: Error {
    case `internal`(code: Int, str: String)
}
