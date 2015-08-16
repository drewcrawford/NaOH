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
public func crypto_box(var plaintext: [UInt8], to: PublicKey, from: Key, var nonce: [UInt8] = sodium_random(Int(crypto_box_NONCEBYTES))) throws -> [UInt8] {
    assert(nonce.count == Int(crypto_box_NONCEBYTES))
    var ciphertext = [UInt8](count: Int(crypto_box_macbytes()) + plaintext.count, repeatedValue: 0)
    try! from.unlock()
    defer { try! from.lock() }
    if crypto_box_easy(&ciphertext, &plaintext, UInt64(plaintext.count), &nonce, to.publicKey, from.addr) != 0 {
        throw NaOHError.CryptoBoxError
    }
    return ciphertext
}

public func crypto_box_open(var ciphertext: [UInt8], to: Key, from: PublicKey, var nonce: [UInt8] = sodium_random(Int(crypto_box_NONCEBYTES))) throws -> [UInt8]  {
    assert(nonce.count == Int(crypto_box_NONCEBYTES))
    var plaintext = [UInt8](count: ciphertext.count - crypto_box_macbytes(), repeatedValue: 0)
    try! to.unlock()
    defer { try! to.lock() }
    if crypto_box_open_easy(&plaintext, &ciphertext, UInt64(ciphertext.count), &nonce, from.publicKey, to.addr) != 0 {
        throw NaOHError.CryptoBoxError
    }
    return plaintext
}