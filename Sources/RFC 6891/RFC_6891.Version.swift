extension RFC_6891 {
    /// EDNS Version
    ///
    /// The EDNS version is carried in bits 8-15 of the OPT record TTL field.
    /// Currently, only version 0 is defined.
    ///
    /// ## Version Negotiation
    ///
    /// Per RFC 6891 Section 6.1.3:
    /// - A responder must respond with the highest version it supports
    ///   that is no greater than the version in the request
    /// - If a responder does not support the version, it returns RCODE BADVERS (16)
    public struct Version: RawRepresentable, Sendable, Hashable, Codable, Comparable {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        /// Creates a Version WITHOUT validation
        init(__unchecked: Void, rawValue: UInt8) {
            self.rawValue = rawValue
        }
    }
}

extension RFC_6891.Version {
    /// EDNS version 0 (current version)
    public static let zero = Self(__unchecked: (), rawValue: 0)

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
