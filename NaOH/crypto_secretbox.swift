//
//  crypto_secretbox.swift
//  SwiftSodium
//
//  Created by Drew Crawford on 8/15/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

func sodium_random(size: Int) -> [UInt8] {
    var buf = [UInt8](count: size, repeatedValue: 0)
    randombytes_buf(&buf, size)
    return buf
}

func crypto_secretbox(var message: [UInt8], var nonce: [UInt8] = sodium_random(Int(crypto_secretbox_NONCEBYTES)), key: Key) -> [UInt8] {
    assert(nonce.count == Int(crypto_secretbox_NONCEBYTES))
    var c = [UInt8](count: crypto_secretbox_macbytes() + message.count, repeatedValue: 0)
    try! key.unlock()
    defer { try! key.lock() }
    crypto_secretbox_easy(&c, &message, UInt64(message.count), &nonce, key.addr)
    return c
}

func crypto_secretbox_open(var ciphertext: [UInt8], var nonce: [UInt8], key: Key) throws -> [UInt8] {
    
    var plaintext = [UInt8](count: ciphertext.count - crypto_secretbox_macbytes(), repeatedValue: 0)
    try! key.unlock()
    defer { try! key.lock() }
    
    if crypto_secretbox_open_easy(&plaintext, &ciphertext, UInt64(ciphertext.count), &nonce, key.addr) != 0 {
        throw NaOHError.CryptoBoxError
    }
    return plaintext
}