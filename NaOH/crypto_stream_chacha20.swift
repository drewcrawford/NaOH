//
//  crypto_stream_chacha20.swift
//  NaOH
//
//  Created by Drew Crawford on 9/1/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found inthe top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation
public let crypto_stream_chacha20_NONCESIZE = Int(crypto_stream_chacha20_NONCEBYTES)

public extension Key {
    /**Create a key suitable for use with crypto_stream_chacha20_* */
    public convenience init(forChaCha20: Bool) {
        precondition(forChaCha20 == true)
        self.init(randomSize: Int(crypto_stream_chacha20_KEYBYTES))
    }
}

public func crypto_stream_chacha20_xor(message: [UInt8], nonce: [UInt8], key: Key) -> [UInt8] {
    var nonce = nonce
    var message = message
    precondition(key.size == Int(crypto_stream_chacha20_KEYBYTES))
    precondition(nonce.count==crypto_stream_chacha20_NONCESIZE)
    var xored : [UInt8] = [UInt8](count: message.count, repeatedValue: 0)
    try! key.unlock()
    defer { try! key.lock() }
    if crypto_stream_chacha20_xor(&xored, &message, UInt64(message.count), &nonce, key.addr) != 0 {
        preconditionFailure("crypto_stream_chacha20_xor failure")
    }
    return xored
}