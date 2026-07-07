// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of project contributors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

// RFC_6891.Option.swift
// swift-rfc-6891
//
// RFC 6891 Section 6.1.2: OPT RDATA (Options)

public import Binary_Serializable_Primitives

extension RFC_6891 {
    /// EDNS Option
    ///
    /// Options are carried in the RDATA portion of the OPT record.
    /// Each option is a (code, length, data) tuple.
    ///
    /// ## Wire Format
    ///
    /// ```
    /// +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    /// |                          OPTION-CODE                         |
    /// +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    /// |                         OPTION-LENGTH                        |
    /// +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    /// |                                                               |
    /// /                          OPTION-DATA                          /
    /// /                                                               /
    /// +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    /// ```
    public struct Option: Sendable, Hashable {
        /// Option code
        public let code: Code

        /// Option data
        public let data: [Byte]

        /// Creates an EDNS option
        ///
        /// - Parameters:
        ///   - code: The option code
        ///   - data: The option data
        public init(code: Code, data: [Byte]) {
            self.code = code
            self.data = data
        }

        /// Creates an EDNS option from stdlib `[UInt8]` data.
        ///
        /// Stdlib-interop forwarder; bridges via `[Byte](data)` BSLI.
        @_disfavoredOverload
        public init(code: Code, data: [UInt8]) {
            self.code = code
            self.data = [Byte](data)
        }
    }
}

// MARK: - Option Code

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

        /// LLQ (1): Long-Lived Queries (RFC 8764)
        public static let llq = Self(__unchecked: (), rawValue: 1)

        /// UL (2): Update Lease (draft)
        public static let updateLease = Self(__unchecked: (), rawValue: 2)

        /// NSID (3): Name Server Identifier (RFC 5001)
        public static let nsid = Self(__unchecked: (), rawValue: 3)

        /// DAU (5): DNSSEC Algorithm Understood (RFC 6975)
        public static let dau = Self(__unchecked: (), rawValue: 5)

        /// DHU (6): DS Hash Understood (RFC 6975)
        public static let dhu = Self(__unchecked: (), rawValue: 6)

        /// N3U (7): NSEC3 Hash Understood (RFC 6975)
        public static let n3u = Self(__unchecked: (), rawValue: 7)

        /// ECS (8): Client Subnet (RFC 7871)
        public static let clientSubnet = Self(__unchecked: (), rawValue: 8)

        /// EXPIRE (9): Expire (RFC 7314)
        public static let expire = Self(__unchecked: (), rawValue: 9)

        /// COOKIE (10): DNS Cookie (RFC 7873)
        public static let cookie = Self(__unchecked: (), rawValue: 10)

        /// TCP-KEEPALIVE (11): TCP Keepalive (RFC 7828)
        public static let tcpKeepalive = Self(__unchecked: (), rawValue: 11)

        /// PADDING (12): Padding (RFC 7830)
        public static let padding = Self(__unchecked: (), rawValue: 12)

        /// CHAIN (13): Chain Query (RFC 7901)
        public static let chain = Self(__unchecked: (), rawValue: 13)

        /// KEY-TAG (14): Key Tag (RFC 8145)
        public static let keyTag = Self(__unchecked: (), rawValue: 14)

        /// EXTENDED-ERROR (15): Extended DNS Error (RFC 8914)
        public static let extendedError = Self(__unchecked: (), rawValue: 15)
    }
}

// MARK: - Binary.Serializable

extension RFC_6891.Option: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ option: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        // Option Code (16 bits, network byte order)
        buffer.append(contentsOf: option.code.rawValue.bytes(endianness: .big))

        // Option Length (16 bits, network byte order)
        buffer.append(contentsOf: UInt16(option.data.count).bytes(endianness: .big))

        // Option Data
        buffer.append(contentsOf: option.data)
    }
}
