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

public let crypto_secretbox_NONCESIZE = Int(crypto_secretbox_NONCEBYTES)

/**This is like crypto_secretbox, but it appends the nonce to the end of the ciphertext
- note: The idea is that you don't have to send the nonce separately.*/
public func crypto_secretbox_appendnonce(message: [UInt8], key: Key, nonce: [UInt8] = sodium_random(Int(crypto_secretbox_NONCEBYTES))) throws -> [UInt8] {
    var ciphertext = try crypto_secretbox(message, key: key, nonce: nonce)
    ciphertext.appendContentsOf(nonce)
    return ciphertext
}

/**The companion to crypto_secretbox_appendnonce */
public func crypto_secretbox_open_appendnonce(ciphertextAndNonce: [UInt8], key: Key) throws -> [UInt8] {
    let ciphertext = ciphertextAndNonce[0..<ciphertextAndNonce.count - Int(crypto_secretbox_NONCEBYTES)]
    let nonce = ciphertextAndNonce[ciphertext.count..<ciphertextAndNonce.count]
    return try crypto_secretbox_open([UInt8](ciphertext), key: key, nonce: [UInt8](nonce))
}

public func crypto_secretbox(var message: [UInt8], key: Key, var nonce: [UInt8]) throws -> [UInt8] {
    precondition(nonce.count == Int(crypto_secretbox_NONCEBYTES))
    var c = [UInt8](count: crypto_secretbox_macbytes() + message.count, repeatedValue: 0)
    try! key.unlock()
    defer { try! key.lock() }
    if crypto_secretbox_easy(&c, &message, UInt64(message.count), &nonce, key.addr) != 0 {
        throw NaOHError.CryptoSecretBoxError
    }
    return c
}

public func crypto_secretbox_open(var ciphertext: [UInt8], key: Key, var nonce: [UInt8]) throws -> [UInt8] {
    
    var plaintext = [UInt8](count: ciphertext.count - crypto_secretbox_macbytes(), repeatedValue: 0)
    try! key.unlock()
    defer { try! key.lock() }
    
    if crypto_secretbox_open_easy(&plaintext, &ciphertext, UInt64(ciphertext.count), &nonce, key.addr) != 0 {
        throw NaOHError.CryptoSecretBoxError
    }
    return plaintext
}