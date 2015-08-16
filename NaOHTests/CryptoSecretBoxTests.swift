//
//  CryptoSecretBoxTests.swift
//  SwiftSodium
//
//  Created by Drew Crawford on 8/15/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//propagated, or distributed except according to the terms contained
//  in the LICENSE file.
import XCTest
@testable import NaOH

class CryptoSecretBoxTests : XCTestCase {
    private let NotReallyNonce: [UInt8] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    private let known_ciphertext: [UInt8] = [238,208,130,110,75,188,8,14,80,51,115,51,112,13,233,240,85,118,104]
    private let known_plaintext: [UInt8] = [0,1,2]
    func testEncrypt() {
        let k = try! Key(password: "My password", salt: "My salt is 32 characters   sjej")
        let result = try! crypto_secretbox([0,1,2], nonce: NotReallyNonce, key: k)
        XCTAssert(result == known_ciphertext)
    }
    
    func testDecrypt() {
        let k = try! Key(password: "My password", salt: "My salt is 32 characters   sjej")
        let result = try! crypto_secretbox_open(known_ciphertext, nonce: NotReallyNonce, key: k)
        XCTAssert(result == known_plaintext)
    }
    
    func testBadDecrypt() {
        let k = try! Key(password: "My password", salt: "My salt is 32 characters   sjej")
        var badCipher = known_ciphertext
        badCipher[3] = 2
        do {
            try crypto_secretbox_open(badCipher, nonce: NotReallyNonce, key: k)
            XCTFail()
        }
        catch NaOHError.CryptoSecretBoxError { /* */ }
        catch { XCTFail("\(error)") }
    }
    
}

import Foundation
