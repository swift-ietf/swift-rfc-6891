# swift-rfc-6891

Use this package when you build DNS messages yourself and need to add the EDNS(0) OPT record, to advertise a larger UDP payload size, set the DNSSEC OK bit or send EDNS options. Start from `RFC_6891.OPT`. The package only writes OPT records. It does not read them back from a response. If you want to resolve names rather than build messages, use swift-domain-name-system.

## Laws

- An OPT record is written as the whole pseudo-record: a root name (one zero byte), type 41, the UDP payload size in the class field, then the TTL field, the data length and the options. Every multi-byte field is big-endian.
- The TTL field holds the extended RCODE byte, the version byte, then 16 flag bits in which only the DNSSEC OK bit, the highest one, can be set.
- The data length is computed from the options. Options are written in the order given, each as its code, the length of its data and the data.
- The payload size is written as given. It is not raised to the 512-byte minimum.
- `RFC_6891.ExtendedRcode.fullRcode(headerRcode:)` shifts the extended RCODE left by four bits and adds the low four bits of the header RCODE, ignoring the header value's upper bits.
