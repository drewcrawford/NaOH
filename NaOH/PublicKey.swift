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
    public let publicKey : [UInt8]
    public let secretKey : Key?
    
    /**Generates a random key */
    public init() {
        var pk = [UInt8](count: Int(crypto_box_PUBLICKEYBYTES), repeatedValue: 0)
        secretKey = Key(uninitializedSize: Int(crypto_box_SECRETKEYBYTES))
        
        if crypto_box_keypair(&pk, secretKey!.addr) != 0 {
            preconditionFailure("Can't generate keypair")
        }
        try! secretKey!.lock()
        publicKey = pk
    }
    
    public init(secretKey: Key) {
        self.secretKey = secretKey
        try! secretKey.unlock()
        defer { try! secretKey.lock() }
        
        var pk = [UInt8](count: Int(crypto_box_PUBLICKEYBYTES), repeatedValue: 0)
        if crypto_scalarmult_base(&pk, secretKey.addr) != 0 {
            preconditionFailure("Can't generate keypair")
        }
        publicKey = pk
    }
}