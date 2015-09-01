//
//  crypto_stream_chacha20.swift
//  NaOH
//
//  Created by Drew Crawford on 9/1/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation
public let crypto_stream_chacha20_NONCESIZE = Int(crypto_stream_chacha20_NONCEBYTES)

public extension Key {
    /**Create a key suitable for use with crypto_stream_chacha20_* */
    public convenience init(forChaCha20: Bool) {
        assert(forChaCha20 == true)
        self.init(randomSize: Int(crypto_stream_chacha20_KEYBYTES))
    }
}

public func crypto_stream_chacha20_xor(var message: [UInt8], var nonce: [UInt8], key: Key) -> [UInt8] {
    assert(key.size == Int(crypto_stream_chacha20_KEYBYTES))
    assert(nonce.count==crypto_stream_chacha20_NONCESIZE)
    var xored : [UInt8] = [UInt8](count: message.count, repeatedValue: 0)
    try! key.unlock()
    defer { try! key.lock() }
    if crypto_stream_chacha20_xor(&xored, &message, UInt64(message.count), &nonce, key.addr) != 0 {
        preconditionFailure("crypto_stream_chacha20_xor failure")
    }
    return xored
}