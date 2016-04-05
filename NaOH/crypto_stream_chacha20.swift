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

@available(iOS 9.3, *, *)
public let crypto_stream_chacha20_NONCESIZE = Int(crypto_stream_chacha20_NONCEBYTES)

@available(iOS 9.3, *, *)
public struct ChaCha20SecretKey : SecretKey {
    public let keyImpl_ : KeyImplProtocol_
    public var description: String { return keyImpl__.description }
    public init(readFromFile: String) throws {
        self.keyImpl_ = try KeyImpl(readFromFile: readFromFile)
    }
    ///Generates a random key
    public init() {
        self.keyImpl_ = KeyImpl(randomSize: Int(crypto_stream_chacha20_KEYBYTES))
    }
}

@available(iOS 9.3, *, *)
public func crypto_stream_chacha20_xor(message: [UInt8], nonce: [UInt8], key: ChaCha20SecretKey) -> [UInt8] {
    var nonce = nonce
    var message = message
    precondition(key.keyImpl__.size == Int(crypto_stream_chacha20_KEYBYTES))
    precondition(nonce.count==crypto_stream_chacha20_NONCESIZE)
    var xored : [UInt8] = [UInt8](repeating: 0, count: message.count)
    try! key.keyImpl__.unlock()
    defer { try! key.keyImpl__.lock() }
    if crypto_stream_chacha20_xor(&xored, &message, UInt64(message.count), &nonce, key.keyImpl__.addr) != 0 {
        preconditionFailure("crypto_stream_chacha20_xor failure")
    }
    return xored
}