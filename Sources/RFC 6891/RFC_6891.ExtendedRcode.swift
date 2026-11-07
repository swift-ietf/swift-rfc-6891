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
    /// Extended RCODE values (12-bit)
    ///
    /// These are the full 12-bit RCODE values used with EDNS.
    public enum Rcode {
        /// NOERROR (0): No error
        public static let noError: UInt16 = 0

        /// FORMERR (1): Format error
        public static let formatError: UInt16 = 1

        /// SERVFAIL (2): Server failure
        public static let serverFailure: UInt16 = 2

        /// NXDOMAIN (3): Non-existent domain
        public static let nxDomain: UInt16 = 3

        /// NOTIMP (4): Not implemented
        public static let notImplemented: UInt16 = 4

        /// REFUSED (5): Query refused
        public static let refused: UInt16 = 5

        /// BADVERS (16): Bad OPT version
        public static let badVersion: UInt16 = 16

        /// BADSIG (16): TSIG signature failure (same value, different context)
        public static let badSignature: UInt16 = 16

        /// BADKEY (17): Key not recognized
        public static let badKey: UInt16 = 17

        /// BADTIME (18): Signature out of time window
        public static let badTime: UInt16 = 18

        /// BADMODE (19): Bad TKEY mode
        public static let badMode: UInt16 = 19

        /// BADNAME (20): Duplicate key name
        public static let badName: UInt16 = 20

        /// BADALG (21): Algorithm not supported
        public static let badAlgorithm: UInt16 = 21

        /// BADTRUNC (22): Bad truncation
        public static let badTruncation: UInt16 = 22

        /// BADCOOKIE (23): Bad/missing server cookie
        public static let badCookie: UInt16 = 23
    }
}
