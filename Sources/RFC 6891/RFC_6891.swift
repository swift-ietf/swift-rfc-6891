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

// RFC_6891.swift
// swift-rfc-6891
//
// RFC 6891: Extension Mechanisms for DNS (EDNS(0)) (April 2013)
// https://www.rfc-editor.org/rfc/rfc6891.html
//
// This package implements EDNS as defined by RFC 6891.
// EDNS extends DNS with additional capabilities via the OPT pseudo-RR.

/// RFC 6891: Extension Mechanisms for DNS (EDNS(0))
///
/// This namespace contains types for EDNS as defined in RFC 6891 from April 2013.
///
/// EDNS(0) extends the DNS protocol to support larger messages and additional
/// capabilities.
///
/// ## Key Types
///
/// - ``OPT``: The OPT pseudo-resource record
/// - ``Option``: EDNS options carried in the OPT record
/// - ``Version``: EDNS version number
///
/// ## OPT Pseudo-RR
///
/// The OPT record is placed in the additional section of DNS messages.
/// It is not a real RR; it is a container for EDNS information.
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
/// ## Example
///
/// ```swift
/// // Create an OPT record advertising 4096-byte UDP support
/// let opt = RFC_6891.OPT(
///     udpPayloadSize: 4096,
///     extendedRcode: 0,
///     version: .zero,
///     dnssecOK: true,
///     options: []
/// )
/// ```
///
/// ## See Also
///
/// - [RFC 6891](https://www.rfc-editor.org/rfc/rfc6891)
/// - ``RFC_1035`` for the base DNS specification
public enum RFC_6891 {}

extension RFC_6891 {
    /// OPT resource record type value
    ///
    /// Per RFC 6891 Section 6.1.1, the OPT RR has type code 41.
    public static let optType: UInt16 = 41
}
