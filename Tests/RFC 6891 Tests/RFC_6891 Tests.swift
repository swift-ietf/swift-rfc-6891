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

import Testing
@testable import RFC_6891

@Suite
struct `RFC 6891 EDNS Tests` {

    @Suite
    struct `Constants Tests` {
        @Test
        func `OPT type is 41`() {
            #expect(RFC_6891.optType == 41)
        }
    }

    @Suite
    struct `Version Tests` {
        @Test
        func `Version zero`() {
            #expect(RFC_6891.Version.zero.rawValue == 0)
        }

        @Test
        func `Version is comparable`() {
            let v0 = RFC_6891.Version.zero
            let v1 = RFC_6891.Version(rawValue: 1)
            #expect(v0 < v1)
        }
    }

    @Suite
    struct `ExtendedRcode Tests` {
        @Test
        func `Zero extended RCODE`() {
            #expect(RFC_6891.ExtendedRcode.zero.rawValue == 0)
        }

        @Test
        func `Full RCODE calculation`() {
            let extended = RFC_6891.ExtendedRcode(rawValue: 1)
            let full = extended.fullRcode(headerRcode: 0)
            #expect(full == 16)  // BADVERS
        }

        @Test
        func `Known RCODE values`() {
            #expect(RFC_6891.Rcode.noError == 0)
            #expect(RFC_6891.Rcode.badVersion == 16)
            #expect(RFC_6891.Rcode.badCookie == 23)
        }
    }

    @Suite
    struct `Option Tests` {
        @Test
        func `Option code values`() {
            #expect(RFC_6891.Option.Code.nsid.rawValue == 3)
            #expect(RFC_6891.Option.Code.clientSubnet.rawValue == 8)
            #expect(RFC_6891.Option.Code.cookie.rawValue == 10)
            #expect(RFC_6891.Option.Code.padding.rawValue == 12)
        }

        @Test
        func `Create and serialize option`() {
            let option = RFC_6891.Option(
                code: .nsid,
                data: [Byte](utf8: "test")
            )

            var buffer: [Byte] = []
            RFC_6891.Option.serialize(option, into: &buffer)

            // 2 bytes code + 2 bytes length + 4 bytes data
            #expect(buffer.count == 8)
            // Code = 3 (NSID)
            #expect(buffer[0] == Byte(0))
            #expect(buffer[1] == Byte(3))
            // Length = 4
            #expect(buffer[2] == Byte(0))
            #expect(buffer[3] == Byte(4))
        }
    }

    @Suite
    struct `OPT Record Tests` {
        @Test
        func `Default OPT record`() {
            let opt = RFC_6891.OPT.default

            #expect(opt.udpPayloadSize == 4096)
            #expect(opt.extendedRcode == .zero)
            #expect(opt.version == .zero)
            #expect(opt.dnssecOK == false)
            #expect(opt.options.isEmpty)
        }

        @Test
        func `DNSSEC OPT record`() {
            let opt = RFC_6891.OPT.dnssec

            #expect(opt.dnssecOK == true)
        }

        @Test
        func `Custom OPT record`() {
            let opt = RFC_6891.OPT(
                udpPayloadSize: 1232,
                extendedRcode: .zero,
                version: .zero,
                dnssecOK: true,
                options: [
                    RFC_6891.Option(code: .padding, data: Array(repeating: 0, count: 10))
                ]
            )

            #expect(opt.udpPayloadSize == 1232)
            #expect(opt.dnssecOK == true)
            #expect(opt.options.count == 1)
        }

        @Test
        func `Serialize OPT record`() {
            let opt = RFC_6891.OPT(
                udpPayloadSize: 4096,
                extendedRcode: .zero,
                version: .zero,
                dnssecOK: false,
                options: []
            )

            var buffer: [Byte] = []
            RFC_6891.OPT.serialize(opt, into: &buffer)

            // NAME (1) + TYPE (2) + CLASS (2) + TTL (4) + RDLENGTH (2) = 11 bytes minimum
            #expect(buffer.count == 11)

            // NAME = 0 (root)
            #expect(buffer[0] == Byte(0))

            // TYPE = 41
            #expect(buffer[1] == Byte(0))
            #expect(buffer[2] == Byte(41))

            // CLASS = 4096 = 0x1000
            #expect(buffer[3] == Byte(0x10))
            #expect(buffer[4] == Byte(0x00))

            // RDLENGTH = 0 (no options)
            #expect(buffer[9] == Byte(0))
            #expect(buffer[10] == Byte(0))
        }

        @Test
        func `Serialize OPT with DNSSEC flag`() {
            let opt = RFC_6891.OPT(dnssecOK: true)

            var buffer: [Byte] = []
            RFC_6891.OPT.serialize(opt, into: &buffer)

            // TTL byte 2 should have DO bit set (0x80)
            #expect(buffer[7] == Byte(0x80))
        }

        @Test
        func `Serialize OPT with options`() {
            let opt = RFC_6891.OPT(
                options: [
                    RFC_6891.Option(code: .nsid, data: [0x01, 0x02, 0x03])
                ]
            )

            var buffer: [Byte] = []
            RFC_6891.OPT.serialize(opt, into: &buffer)

            // RDLENGTH should be 7 (2 code + 2 length + 3 data)
            #expect(buffer[9] == Byte(0))
            #expect(buffer[10] == Byte(7))

            // Total = 11 + 7 = 18 bytes
            #expect(buffer.count == 18)
        }

        @Test
        func `UDP payload size constants`() {
            #expect(RFC_6891.OPT.minimumUDPPayloadSize == 512)
            #expect(RFC_6891.OPT.defaultUDPPayloadSize == 4096)
            #expect(RFC_6891.OPT.maximumUDPPayloadSize == 65535)
        }
    }
}
