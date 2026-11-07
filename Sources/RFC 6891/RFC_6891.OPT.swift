public import Binary

extension RFC_6891 {
    /// OPT Pseudo-Resource Record
    ///
    /// The OPT pseudo-RR is placed in the additional section of DNS messages
    /// to indicate EDNS support and carry EDNS options.
    ///
    /// ## Wire Format
    ///
    /// ```
    /// +------------+--------------+------------------------------+
    /// | Field Name | Field Type   | Description                  |
    /// +------------+--------------+------------------------------+
    /// | NAME       | domain name  | MUST be 0 (root domain)      |
    /// | TYPE       | u_int16_t    | OPT (41)                     |
    /// | CLASS      | u_int16_t    | requestor's UDP payload size |
    /// | TTL        | u_int32_t    | extended RCODE and flags     |
    /// | RDLENGTH   | u_int16_t    | length of all RDATA          |
    /// | RDATA      | octet stream | {attribute,value} pairs      |
    /// +------------+--------------+------------------------------+
    /// ```
    ///
    /// ## TTL Field Structure
    ///
    /// ```
    /// +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    /// |         EXTENDED-RCODE        |            VERSION            |
    /// +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    /// | DO|                           Z                               |
    /// +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    /// ```
    public struct OPT: Sendable, Hashable {
        /// Requestor's UDP payload size
        ///
        /// The maximum UDP payload size the requestor can reassemble.
        /// Per RFC 6891, this should be at least 512.
        public let udpPayloadSize: UInt16

        /// Extended RCODE (upper 8 bits)
        public let extendedRcode: ExtendedRcode

        /// EDNS version
        public let version: Version

        /// DNSSEC OK flag
        ///
        /// When set, indicates the resolver can handle DNSSEC data.
        public let dnssecOK: Bool

        /// EDNS options
        public let options: [Option]

        /// Creates an OPT record
        public init(
            udpPayloadSize: UInt16 = 4096,
            extendedRcode: ExtendedRcode = .zero,
            version: Version = .zero,
            dnssecOK: Bool = false,
            options: [Option] = []
        ) {
            self.udpPayloadSize = udpPayloadSize
            self.extendedRcode = extendedRcode
            self.version = version
            self.dnssecOK = dnssecOK
            self.options = options
        }
    }
}

extension RFC_6891.OPT {
    /// Minimum recommended UDP payload size (512 bytes)
    public static let minimumUDPPayloadSize: UInt16 = 512

    /// Default UDP payload size (4096 bytes)
    public static let defaultUDPPayloadSize: UInt16 = 4096

    /// Maximum UDP payload size
    public static let maximumUDPPayloadSize: UInt16 = 65535
}

extension RFC_6891.OPT: Binary.Serializable {
    /// Serializes the OPT record to wire format
    ///
    /// This serializes the complete OPT pseudo-RR including:
    /// - NAME (root = 0)
    /// - TYPE (41)
    /// - CLASS (UDP payload size)
    /// - TTL (extended RCODE, version, flags)
    /// - RDLENGTH
    /// - RDATA (options)
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ opt: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(Byte(0))

        buffer.append(Byte(0))
        buffer.append(Byte(41))

        buffer.append(contentsOf: opt.udpPayloadSize.bytes(endianness: .big))

        buffer.append(Byte(opt.extendedRcode.rawValue))
        buffer.append(Byte(opt.version.rawValue))

        var flags: UInt16 = 0
        if opt.dnssecOK {
            flags |= 0x8000
        }
        buffer.append(contentsOf: flags.bytes(endianness: .big))

        var optionData: [Byte] = []
        for option in opt.options {
            RFC_6891.Option.serialize(option, into: &optionData)
        }

        buffer.append(contentsOf: UInt16(optionData.count).bytes(endianness: .big))

        buffer.append(contentsOf: optionData)
    }
}

extension RFC_6891.OPT {
    /// Creates a default EDNS(0) OPT record
    ///
    /// Uses recommended defaults:
    /// - 4096-byte UDP payload size
    /// - Version 0
    /// - No DNSSEC
    /// - No options
    public static var `default`: Self {
        Self(
            udpPayloadSize: defaultUDPPayloadSize,
            extendedRcode: .zero,
            version: .zero,
            dnssecOK: false,
            options: []
        )
    }

    /// Creates an EDNS(0) OPT record with DNSSEC support
    ///
    /// Uses recommended defaults with DNSSEC OK flag set.
    public static var dnssec: Self {
        Self(
            udpPayloadSize: defaultUDPPayloadSize,
            extendedRcode: .zero,
            version: .zero,
            dnssecOK: true,
            options: []
        )
    }
}
