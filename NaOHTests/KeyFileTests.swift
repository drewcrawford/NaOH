//
//  KeyFileTests.swift
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
import CarolineCore
@testable import NaOH

class KeyLoadSave: CarolineTest {
    func test() {
        let temporaryFile = NSTemporaryDirectory() + "/\(NSUUID().uuidString)test.key"
        let k = CryptoBoxSecretKey()
        try! k.saveToFile(temporaryFile)
        
        let j = try! CryptoBoxSecretKey(readFromFile: temporaryFile)
        self.assert(k.keyImpl__.hash, equals: j.keyImpl__.hash)
    }
}

class PublicKeyLoadSave: CarolineTest {
    func test() {
        let pk = CryptoBoxSecretKey().publicKey
        let temporaryFile = NSTemporaryDirectory() + "/\(NSUUID().uuidString)test.key"
        try! pk.saveToFile(temporaryFile)
        
        let pk2 = try! CryptoBoxPublicKey(readFromFile: temporaryFile)
        self.assert(pk.bytes, equals: pk2.bytes)
    }
}
