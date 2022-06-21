public struct HTTPHeader: Equatable, CustomStringConvertible {
    let name: String
    let value: String

    public init(_ name: String, _ value: String) {
        self.name = name
        self.value = value
    }

    public var description: String {
        "\(name): \(value)"
    }
}
