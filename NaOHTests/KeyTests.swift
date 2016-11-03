//
//  KeyTests.swift
//  SwiftSodium
//
//  Created by Drew Crawford on 8/15/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found inthe top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  inthe LICENSE file.

import Foundation
import CarolineCore
@testable import NaOH

class KeyTest: CarolineTest {
    func test() {
        let k = try! CryptoSecretBoxSecretKey(password: "My password", salt: "My salt is 32 characters   sjej", keySize: KeySizes.crypto_box_seed)
        self.assert(k.keyImpl__.hash, equals: "C2D877E295C0070384F1486F18CE136C72B050EFAB71D2830260F2A062B9E2AC", "k.hash isn't the right value: \(k.keyImpl__.hash)")
    }
}

class ZeroImport: CarolineTest {
    func test() {
        var k : [UInt8] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32]
        let _ = KeyImpl(zeroingMemory: &k)
        self.assert(k, equals: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    }
}

class Crypto: CarolineTest {
    func test() {
        let alice = CryptoBoxSecretKey()
        let bob = CryptoBoxSecretKey()
        let jeff = CryptoSecretBoxSecretKey()
        let keyData = try! jeff.encrypted(toPublicKey: alice.publicKey, fromKey: bob, appendNonce:true)
        let key2 = try! CryptoSecretBoxSecretKey(decrypt: keyData, secretKey: alice, fromKey: bob.publicKey)
        self.assert(key2.keyImpl__.hash, equals: jeff.keyImpl__.hash)
    }
}

class OverwriteKey: CarolineTest {
    func test() {
        let temporaryFile = NSTemporaryDirectory() + "/\(NSUUID().uuidString)test.key"
        let alice = CryptoBoxSecretKey()
        try! alice.saveToFile(temporaryFile)
        do {
            try alice.saveToFile(temporaryFile)
            self.fail("Overwrote existing key")
        }
        catch NaOHError.WontOverwriteKey { /* */ }
        catch { self.fail("\(error)") }
    }
}

class CryptoBoxKey: CarolineTest {
    func test() {
        let _ = CryptoBoxSecretKey()
    }
}

class CryptoBoxFromBytes: CarolineTest {
    func test() throws {
        let temporaryFile = NSTemporaryDirectory() + "/\(NSUUID().uuidString)test.key"

        let key1 = CryptoBoxSecretKey()
        try key1.saveToFile(temporaryFile)
        let bytes = try Data(contentsOf: URL(fileURLWithPath: temporaryFile))
        var array = bytes.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: bytes.count))
        }
        let _ = CryptoBoxSecretKey(bytes: &array)
        self.assert(array, equals: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    }
}

class HumanReadable : CarolineTest {
    func test() {
        let a = CryptoBoxSecretKey().publicKey
        let str = a.humanReadable
        let b = CryptoBoxPublicKey(humanReadableString: str)
        self.assert(a, equals: b)
    }
}

