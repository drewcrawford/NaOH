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

#if ATBUILD
    import CSodium
#endif

public let crypto_secretbox_NONCESIZE = Int(crypto_secretbox_NONCEBYTES)

/**This is like crypto_secretbox, but it appends the nonce to the end of the ciphertext
- note: The idea is that you don't have to send the nonce separately.*/
public func crypto_secretbox_appendnonce(message: [UInt8], key: Key, nonce: Integer192Bit = Integer192Bit(random: true)) throws -> [UInt8] {
    var ciphertext = try crypto_secretbox(message, key: key, nonce: nonce)
    ciphertext.append(contentsOf: nonce.byteRepresentation)
    return ciphertext
}

/**The companion to crypto_secretbox_appendnonce */
public func crypto_secretbox_open_appendnonce(ciphertextAndNonce: [UInt8], key: Key) throws -> [UInt8] {
    let ciphertext = ciphertextAndNonce[0..<ciphertextAndNonce.count - Int(crypto_secretbox_NONCEBYTES)]
    let nonce = Integer192Bit(array: [UInt8](ciphertextAndNonce[ciphertext.count..<ciphertextAndNonce.count]))
    return try crypto_secretbox_open([UInt8](ciphertext), key: key, nonce: nonce)
}

public func crypto_secretbox(message: [UInt8], key: Key, nonce: Integer192Bit) throws -> [UInt8] {
    var message = message
    var nonce = nonce
    precondition(nonce.byteRepresentation.count == Int(crypto_secretbox_NONCEBYTES))
    var c = [UInt8](repeating: 0, count: crypto_secretbox_macbytes() + message.count)
    try! key.unlock()
    defer { try! key.lock() }
    if crypto_secretbox_easy(&c, &message, UInt64(message.count), &nonce.byteRepresentation, key.addr) != 0 {
        throw NaOHError.CryptoSecretBoxError
    }
    return c
}

public func crypto_secretbox_open(ciphertext: [UInt8], key: Key, nonce: Integer192Bit) throws -> [UInt8] {
    var ciphertext = ciphertext
    var nonce = nonce
    var plaintext = [UInt8](repeating: 0, count: ciphertext.count - crypto_secretbox_macbytes())
    try! key.unlock()
    defer { try! key.lock() }
    
    if crypto_secretbox_open_easy(&plaintext, &ciphertext, UInt64(ciphertext.count), &nonce.byteRepresentation, key.addr) != 0 {
        throw NaOHError.CryptoSecretBoxError
    }
    return plaintext
}