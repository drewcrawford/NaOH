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
#if ATBUILD
    import CSodium
#endif

public func crypto_box_nonce() -> Integer192Bit {
    return Integer192Bit(random: true)
}

/**This is like crypto_secretbox, but it appends the nonce to the end of the ciphertext
- note: The idea is that you don't have to send the nonce separately.
*/
public func crypto_box_appendnonce(plaintext: [UInt8], to: PublicKey, from: Key, nonce: Integer192Bit = crypto_box_nonce()) throws -> [UInt8] {
    precondition(nonce.byteRepresentation.count == Int(crypto_box_NONCEBYTES),"Invalid nonce size \(nonce.byteRepresentation.count).")

    var ciphertext = try crypto_box(plaintext, to: to, from: from, nonce: nonce)
    ciphertext.append(contentsOf: nonce.byteRepresentation)
    return ciphertext
}

/**The companion to crypto_box_appendnonce */
public func crypto_box_open_appendnonce(ciphertextAndNonce: [UInt8], to: Key, from: PublicKey) throws -> [UInt8]  {
    let ciphertext = ciphertextAndNonce[0..<ciphertextAndNonce.count - Int(crypto_box_NONCEBYTES)]
    let nonce = Integer192Bit(array: [UInt8](ciphertextAndNonce[ciphertext.count..<ciphertextAndNonce.count]))
    return try crypto_box_open([UInt8](ciphertext), to: to, from: from, nonce: nonce)
}


public func crypto_box(plaintext: [UInt8], to: PublicKey, from: Key, nonce: Integer192Bit) throws -> [UInt8] {
    var plaintext = plaintext
    var nonce = nonce
    precondition(nonce.byteRepresentation.count == Int(crypto_box_NONCEBYTES),"Invalid nonce size \(nonce.byteRepresentation.count).")
    var ciphertext = [UInt8](repeating: 0, count: Int(crypto_box_macbytes()) + plaintext.count)
    try! from.unlock()
    defer { try! from.lock() }
    if crypto_box_easy(&ciphertext, &plaintext, UInt64(plaintext.count), &nonce.byteRepresentation, to.bytes, from.addr) != 0 {
        throw NaOHError.CryptoBoxError
    }
    return ciphertext
}

public func crypto_box_open(ciphertext: [UInt8], to: Key, from: PublicKey, nonce: Integer192Bit) throws -> [UInt8]  {
    var ciphertext = ciphertext
    var nonce = nonce
    precondition(nonce.byteRepresentation.count == Int(crypto_box_NONCEBYTES))
    var plaintext = [UInt8](repeating: 0, count: ciphertext.count - crypto_box_macbytes())
    try! to.unlock()
    defer { try! to.lock() }
    if crypto_box_open_easy(&plaintext, &ciphertext, UInt64(ciphertext.count), &nonce.byteRepresentation, from.bytes, to.addr) != 0 {
        throw NaOHError.CryptoBoxError
    }
    return plaintext
}