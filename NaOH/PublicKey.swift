//
//  PublicKey.swift
//  NaOH
//
//  Created by Drew Crawford on 8/16/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found inthe top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation
public final class PublicKey {
    public let bytes : [UInt8]
    public let secretKey : Key?
    
    /**Generates a random key */
    public init() {
        var pk = [UInt8](repeating: 0, count: Int(crypto_box_PUBLICKEYBYTES))
        secretKey = Key(uninitializedSize: Int(crypto_box_SECRETKEYBYTES))
        
        if crypto_box_keypair(&pk, secretKey!.addr) != 0 {
            preconditionFailure("Can't generate keypair")
        }
        try! secretKey!.lock()
        bytes = pk
    }
    
    public init(secretKey: Key) {
        self.secretKey = secretKey
        try! secretKey.unlock()
        defer { try! secretKey.lock() }
        
        var pk = [UInt8](repeating: 0, count:  Int(crypto_box_PUBLICKEYBYTES))
        if crypto_scalarmult_base(&pk, secretKey.addr) != 0 {
            preconditionFailure("Can't generate keypair")
        }
        bytes = pk
    }
    
    /**Creates a public key without a corresponding secret key. */
    public init(publicKeyBytes: [UInt8]) {
        self.bytes = publicKeyBytes
        self.secretKey = nil
    }
}

func == (a: PublicKey, b: PublicKey) -> Bool {
    return a.bytes == b.bytes
}