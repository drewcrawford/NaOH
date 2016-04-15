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

@available(iOS 9.3, *, *)
public func crypto_box_nonce() -> Integer192Bit {
    return Integer192Bit(random: true)
}

@available(iOS 9.3, *, *)
public struct CryptoBoxSecretKey : SecretKey {
    public let keyImpl_ : KeyImplProtocol_
    public var description: String { return keyImpl__.description }
    
    public let publicKey: CryptoBoxPublicKey
    
    /**Generates a random key */
    public init() {
        var pk = [UInt8](repeating: 0, count: Int(crypto_box_PUBLICKEYBYTES))
        self.keyImpl_ = KeyImpl(uninitializedSize: Int(crypto_box_SECRETKEYBYTES))
        
        if crypto_box_keypair(&pk, (keyImpl_ as! KeyImpl).addr) != 0 {
            preconditionFailure("Can't generate keypair")
        }
        try! (keyImpl_ as! KeyImpl).lock()
        publicKey = CryptoBoxPublicKey(bytes: pk)
    }
    public init(readFromFile: String) throws {
        self.keyImpl_ = try KeyImpl(readFromFile: readFromFile)
        self.publicKey = CryptoBoxPublicKey(secretKeyImpl: self.keyImpl_ as! KeyImpl)
    }
}
@available(iOS 9.3, *, *)
public struct CryptoBoxPublicKey: PublicKey {
    public var bytes: [UInt8]
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    private init(secretKeyImpl: KeyImpl) {
        try! secretKeyImpl.unlock()
        defer { try! secretKeyImpl.lock() }
        
        var pk = [UInt8](repeating: 0, count:  Int(crypto_box_PUBLICKEYBYTES))
        if crypto_scalarmult_base(&pk, secretKeyImpl.addr) != 0 {
            preconditionFailure("Can't generate keypair")
        }
        bytes = pk
    }
    public init(secretKey: CryptoBoxSecretKey) {
        self.init(secretKeyImpl: secretKey.keyImpl__)
    }
    public init(humanReadableString: String) {
        let data = NSData(base64Encoded: humanReadableString, options: NSDataBase64DecodingOptions())!
        var array = [UInt8](repeating: 0, count: data.length)
        data.getBytes(&array,length:data.length)
        self.init(bytes: array)
    }
    public init(readFromFile: String) throws {
        self.bytes = try publicKeyReadFromFile(readFromFile)
    }
}

/**This is like crypto_secretbox, but it appends the nonce to the end of the ciphertext
- note: The idea is that you don't have to send the nonce separately.
*/
@available(iOS 9.3, *, *)
public func crypto_box_appendnonce(_ plaintext: [UInt8], to: CryptoBoxPublicKey, from: CryptoBoxSecretKey, nonce: Integer192Bit = crypto_box_nonce()) throws -> [UInt8] {
    precondition(nonce.byteRepresentation.count == Int(crypto_box_NONCEBYTES),"Invalid nonce size \(nonce.byteRepresentation.count).")

    var ciphertext = try crypto_box(plaintext, to: to, from: from, nonce: nonce)
    ciphertext.append(contentsOf: nonce.byteRepresentation)
    return ciphertext
}

/**The companion to crypto_box_appendnonce */
@available(iOS 9.3, *, *)
public func crypto_box_open_appendnonce(_ ciphertextAndNonce: [UInt8], to: CryptoBoxSecretKey, from: CryptoBoxPublicKey) throws -> [UInt8]  {
    let ciphertext = ciphertextAndNonce[0..<ciphertextAndNonce.count - Int(crypto_box_NONCEBYTES)]
    let nonce = Integer192Bit(array: [UInt8](ciphertextAndNonce[ciphertext.count..<ciphertextAndNonce.count]))
    return try crypto_box_open([UInt8](ciphertext), to: to, from: from, nonce: nonce)
}

@available(iOS 9.3, *, *)
public func crypto_box(_ plaintext: [UInt8], to: CryptoBoxPublicKey, from: CryptoBoxSecretKey, nonce: Integer192Bit) throws -> [UInt8] {
    var plaintext = plaintext
    var nonce = nonce
    precondition(nonce.byteRepresentation.count == Int(crypto_box_NONCEBYTES),"Invalid nonce size \(nonce.byteRepresentation.count).")
    var ciphertext = [UInt8](repeating: 0, count: Int(crypto_box_macbytes()) + plaintext.count)
    try! from.keyImpl__.unlock()
    defer { try! from.keyImpl__.lock() }
    if crypto_box_easy(&ciphertext, &plaintext, UInt64(plaintext.count), &nonce.byteRepresentation, to.bytes, from.keyImpl__.addr) != 0 {
        throw NaOHError.CryptoBoxError
    }
    return ciphertext
}

@available(iOS 9.3, *, *)
public func crypto_box_open(_ ciphertext: [UInt8], to: CryptoBoxSecretKey, from: CryptoBoxPublicKey, nonce: Integer192Bit) throws -> [UInt8]  {
    var ciphertext = ciphertext
    var nonce = nonce
    precondition(nonce.byteRepresentation.count == Int(crypto_box_NONCEBYTES))
    var plaintext = [UInt8](repeating: 0, count: ciphertext.count - crypto_box_macbytes())
    try! to.keyImpl__.unlock()
    defer { try! to.keyImpl__.lock() }
    if crypto_box_open_easy(&plaintext, &ciphertext, UInt64(ciphertext.count), &nonce.byteRepresentation, from.bytes, to.keyImpl__.addr) != 0 {
        throw NaOHError.CryptoBoxError
    }
    return plaintext
}