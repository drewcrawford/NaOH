//
//  CryptoStreamTests.swift
//  NaOH
//
//  Created by Drew Crawford on 9/1/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

import XCTest
@testable import NaOH

class CryptoStreamTestsTests : XCTestCase {
    func testChaCha20() {
        let key = Key(forChaCha20: true)
        let nonce = [UInt8](count: crypto_stream_chacha20_NONCESIZE, repeatedValue: 0)
        let ciphertext = crypto_stream_chacha20_xor([1,2,3], nonce: nonce, key: key)
        let plaintext = crypto_stream_chacha20_xor(ciphertext, nonce: nonce, key: key)
        XCTAssert(plaintext == [1,2,3])
    }
}