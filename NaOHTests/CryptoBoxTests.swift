//
//  CryptoBoxTests.swift
//  NaOH
//
//  Created by Drew Crawford on 8/16/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  inthe LICENSE file.

import Foundation
import CarolineCore
@testable import NaOH

private let knownPlaintext : [UInt8] = [0,1,2]
private let notVeryNonce = Integer192Bit(array: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23])

private let knownCiphertext : [UInt8] = [211, 170, 214, 228, 186, 238, 171, 198, 216, 148, 136, 65, 140, 6, 22, 100, 5, 32, 23]


class CryptoBox : CarolineTest {
    func test() {
        let (alice, bob) = aliceBob()
        let cipher = try! crypto_box(knownPlaintext, to: alice.publicKey, from: bob, nonce: notVeryNonce)
        print("\(cipher)")
        self.assert(cipher, equals: knownCiphertext)
    }
}

class CryptoBoxOpen: CarolineTest {
    func test() {
        let (alice, bob) = aliceBob()
        let plain = try! crypto_box_open(knownCiphertext, to: alice, from: bob.publicKey, nonce: notVeryNonce)
        self.assert(plain, equals: knownPlaintext)
    }
}

func aliceBob() -> (CryptoBoxSecretKey, CryptoBoxSecretKey) {
    #if ATBUILD
        var alicePath = "NaOHTests/alice.key"
        var bobPath = "NaOHTests/bob.key"
    #else
        var alicePath = Bundle(for: CarolineEngineTests.self).path(forResource: "alice", ofType: "key")!
        var bobPath = Bundle(for: CarolineEngineTests.self).path(forResource: "bob", ofType: "key")!
    #endif
    //fix the permsisions on this key so we don't freak out the security goalie
    //on iOS 9.3+, we can't edit the permissions of a file in our app bundle.  Therefore, we have to copy them to a temporary path so the permissions are valid.
    
    #if !os(Linux)
        //copy item at path is unimplimented on Linux, but this feature isn't technically required there.
        let newAlicePath = NSTemporaryDirectory() + "/alice.key"
        let _ = try? FileManager.`default`.removeItem(atPath: newAlicePath)
        try! FileManager.`default`.copyItem(atPath: alicePath, toPath: newAlicePath)
        alicePath = newAlicePath
        let newBobPath = NSTemporaryDirectory() + "/bob.key"
        let _ = try? FileManager.`default`.removeItem(atPath: newBobPath)
        try! FileManager.`default`.copyItem(atPath: bobPath, toPath: newBobPath)
        bobPath = newBobPath
    #endif
    
    try! FileManager.`default`.setSWIFTBUGAttributes([FileAttributeKey.posixPermissions.rawValue: NSNumber(value: 0o0600 as UInt16)], ofItemAtPath: alicePath)
    try! FileManager.`default`.setSWIFTBUGAttributes([FileAttributeKey.posixPermissions.rawValue: NSNumber(value: 0o0600 as UInt16)], ofItemAtPath: bobPath)
    
    let alice = try! CryptoBoxSecretKey(readFromFile: alicePath)
    let bob = try! CryptoBoxSecretKey(readFromFile: bobPath)
    return (alice, bob)
}
