extension IETF.RFC.`6891`.Option {

    public enum Error: Swift::Error, Sendable, Equatable {

        case dataTooLong(_ length: Int)
    }
}

extension IETF.RFC.`6891`.Option.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .dataTooLong(let length):
            return "EDNS option data is too long (\(length) bytes, maximum 65535)"
        }
    }
}
