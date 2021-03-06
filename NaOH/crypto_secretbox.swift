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

@available(iOS 9.3, *, *)
public let crypto_secretbox_NONCESIZE = Int(crypto_secretbox_NONCEBYTES)

@available(iOS 9.3, *, *)
public struct CryptoSecretBoxSecretKey : SecretKey {
    public let keyImpl_: KeyImplProtocol_
    public init() {
        self.keyImpl_ = KeyImpl(randomSize: Int(crypto_secretbox_KEYBYTES))
    }
    
    public init(password: String, salt: String, keySize: KeySizes) throws  {
        self.keyImpl_ = try KeyImpl(password: password, salt: salt, keySize: Int(crypto_secretbox_KEYBYTES))
    }
}

/**This is like crypto_secretbox, but it appends the nonce to the end of the ciphertext
- note: The idea is that you don't have to send the nonce separately.*/
@available(iOS 9.3, *, *)
public func crypto_secretbox_appendnonce(_ message: [UInt8], key: CryptoSecretBoxSecretKey, nonce: Integer192Bit = Integer192Bit(random: true)) throws -> [UInt8] {
    var ciphertext = try crypto_secretbox(message, key: key, nonce: nonce)
    ciphertext.append(contentsOf: nonce.byteRepresentation)
    return ciphertext
}

/**The companion to crypto_secretbox_appendnonce */
@available(iOS 9.3, *, *)
public func crypto_secretbox_open_appendnonce(_ ciphertextAndNonce: [UInt8], key: CryptoSecretBoxSecretKey) throws -> [UInt8] {
    let ciphertext = ciphertextAndNonce[0..<ciphertextAndNonce.count - Int(crypto_secretbox_NONCEBYTES)]
    let nonce = Integer192Bit(array: [UInt8](ciphertextAndNonce[ciphertext.count..<ciphertextAndNonce.count]))
    return try crypto_secretbox_open([UInt8](ciphertext), key: key, nonce: nonce)
}

@available(iOS 9.3, *, *)
public func crypto_secretbox(_ message: [UInt8], key: CryptoSecretBoxSecretKey, nonce: Integer192Bit) throws -> [UInt8] {
    var message = message
    var nonce = nonce
    precondition(nonce.byteRepresentation.count == Int(crypto_secretbox_NONCEBYTES))
    var c = [UInt8](repeating: 0, count: crypto_secretbox_macbytes() + message.count)
    try! key.keyImpl__.unlock()
    defer { try! key.keyImpl__.lock() }
    if crypto_secretbox_easy(&c, &message, UInt64(message.count), &nonce.byteRepresentation, key.keyImpl__.addr) != 0 {
        throw NaOHError.CryptoSecretBoxError
    }
    return c
}

@available(iOS 9.3, *, *)
public func crypto_secretbox_open(_ ciphertext: [UInt8], key: CryptoSecretBoxSecretKey, nonce: Integer192Bit) throws -> [UInt8] {
    var ciphertext = ciphertext
    var nonce = nonce
    var plaintext = [UInt8](repeating: 0, count: ciphertext.count - crypto_secretbox_macbytes())
    try! key.keyImpl__.unlock()
    defer { try! key.keyImpl__.lock() }
    
    if crypto_secretbox_open_easy(&plaintext, &ciphertext, UInt64(ciphertext.count), &nonce.byteRepresentation, key.keyImpl__.addr) != 0 {
        throw NaOHError.CryptoSecretBoxError
    }
    return plaintext
}