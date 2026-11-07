public import Binary


extension RFC_6891.Option {
    /// EDNS Option Code
    ///
    /// Option codes are assigned by IANA.
    public struct Code: RawRepresentable, Sendable, Hashable, Codable {
        public let rawValue: UInt16

        public init(rawValue: UInt16) {
            self.rawValue = rawValue
        }

        /// Creates an Option Code WITHOUT validation
        init(__unchecked: Void, rawValue: UInt16) {
            self.rawValue = rawValue
        }
    }
}
