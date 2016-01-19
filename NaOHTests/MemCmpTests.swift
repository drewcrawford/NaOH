//
//  MemCmpTests.swift
//  NaOH
//
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

import XCTest
@testable import NaOH

class MemCmpTests : XCTestCase {
    func testMemCmp() {
        XCTAssert(sodium_memcmp([1,2,3], [1,2,3]))
        XCTAssert(!sodium_memcmp([1,2,3], [1,3,3]))
    }
}
#if ATBUILD
extension MemCmpTests : XCTestCaseProvider {
    var allTests : [(String, () -> Void)] {
        return [
            ("testMemCmp", testMemCmp)]
    }
}
#endif