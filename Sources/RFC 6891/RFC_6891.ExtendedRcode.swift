extension RFC_6891 {
    /// Extended RCODE
    ///
    /// The upper 8 bits of the extended 12-bit RCODE are carried in the
    /// OPT record TTL field (bits 24-31). Combined with the 4-bit RCODE
    /// in the DNS header, this forms a 12-bit RCODE.
    ///
    /// ## Extended RCODE Calculation
    ///
    /// Full RCODE = (EXTENDED-RCODE << 4) | RCODE
    ///
    /// ## Common Extended Values
    ///
    /// - 0: No extended RCODE (use header RCODE only)
    /// - 1 (+ header 0 = 16): BADVERS - Bad OPT version
    /// - 1 (+ header 1 = 17): BADSIG - TSIG signature failure
    public struct ExtendedRcode: RawRepresentable, Sendable, Hashable, Codable {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        /// Creates an ExtendedRcode WITHOUT validation
        init(__unchecked: Void, rawValue: UInt8) {
            self.rawValue = rawValue
        }

        /// No extended RCODE (use header RCODE only)
        public static let zero = Self(__unchecked: (), rawValue: 0)

        /// Computes the full 12-bit RCODE
        ///
        /// - Parameter headerRcode: The 4-bit RCODE from the DNS header
        /// - Returns: The combined 12-bit RCODE
        public func fullRcode(headerRcode: UInt8) -> UInt16 {
            (UInt16(rawValue) << 4) | UInt16(headerRcode & 0x0F)
        }
    }
}

extension RFC_6891 {
}
