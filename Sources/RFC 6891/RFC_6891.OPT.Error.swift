extension RFC_6891.OPT {

    public enum Error: Swift::Error, Sendable, Equatable {

        case optionsTooLong(_ length: Int)
    }
}

extension RFC_6891.OPT.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .optionsTooLong(let length):
            return "OPT RDATA is too long (\(length) bytes, maximum 65535)"
        }
    }
}
