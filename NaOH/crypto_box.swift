//
//  crypto_box.swift
//  NaOH
//
//  Created by Drew Crawford on 8/16/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found inthe top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  inthe LICENSE file.

import Foundation

public func crypto_box_nonce() -> [UInt8] {
    return sodium_random(Int(crypto_box_NONCEBYTES))
}

/**This is like crypto_secretbox, but it appends the nonce to the end of the ciphertext
- note: The idea is that you don't have to send the nonce separately.
*/
public func crypto_box_appendnonce(plaintext: [UInt8], to: PublicKey, from: Key, nonce: [UInt8] = crypto_box_nonce()) throws -> [UInt8] {
    var ciphertext = try crypto_box(plaintext, to: to, from: from, nonce: nonce)
    ciphertext.extend(nonce)
    return ciphertext
}

/**The companion to crypto_box_appendnonce */
public func crypto_box_open_appendnonce(var ciphertextAndNonce: [UInt8], to: Key, from: PublicKey) throws -> [UInt8]  {
    let ciphertext = ciphertextAndNonce[0..<ciphertextAndNonce.count - Int(crypto_box_NONCEBYTES)]
    let nonce = ciphertextAndNonce[ciphertext.count..<ciphertextAndNonce.count]
    return try crypto_box_open([UInt8](ciphertext), to: to, from: from, nonce: [UInt8](nonce))
}


public func crypto_box(var plaintext: [UInt8], to: PublicKey, from: Key, var nonce: [UInt8]) throws -> [UInt8] {
    assert(nonce.count == Int(crypto_box_NONCEBYTES))
    var ciphertext = [UInt8](count: Int(crypto_box_macbytes()) + plaintext.count, repeatedValue: 0)
    try! from.unlock()
    defer { try! from.lock() }
    if crypto_box_easy(&ciphertext, &plaintext, UInt64(plaintext.count), &nonce, to.publicKey, from.addr) != 0 {
        throw NaOHError.CryptoBoxError
    }
    return ciphertext
}

public func crypto_box_open(var ciphertext: [UInt8], to: Key, from: PublicKey, var nonce: [UInt8]) throws -> [UInt8]  {
    assert(nonce.count == Int(crypto_box_NONCEBYTES))
    var plaintext = [UInt8](count: ciphertext.count - crypto_box_macbytes(), repeatedValue: 0)
    try! to.unlock()
    defer { try! to.lock() }
    if crypto_box_open_easy(&plaintext, &ciphertext, UInt64(ciphertext.count), &nonce, from.publicKey, to.addr) != 0 {
        throw NaOHError.CryptoBoxError
    }
    return plaintext
}