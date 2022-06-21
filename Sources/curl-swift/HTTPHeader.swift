public struct HTTPHeader: Equatable {
    let name: String
    let value: String

    public init(_ name: String, _ value: String) {
        self.name = name
        self.value = value
    }
}
