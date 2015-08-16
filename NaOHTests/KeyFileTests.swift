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
import XCTest
@testable import NaOH

class KeyFileTests : XCTestCase {
    func testKeyLoadSave() {
        let temporaryFile = "/tmp/test.key"
        let k = try! Key(randomSize: 32)
        try! k.saveToFile(temporaryFile)
    
        let j = try! Key(readFromFile: temporaryFile)
        XCTAssert(k.hash == j.hash)
    }
    
    func testPublicKeyLoadSave() {
        let pk = PublicKey()
        try! pk.saveToFile("/tmp/test.key")
        
        let pk2 = try! PublicKey(readFromFile: "/tmp/test.key")
        
        XCTAssert(pk.publicKey == pk2.publicKey)
    }
}