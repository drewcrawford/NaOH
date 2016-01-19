//
//  IncrementTests.swift
//  NaOH
//
//  Created by Drew Crawford on 12/13/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation
import XCTest
@testable import NaOH

class IncrementTestsTests : XCTestCase {
    func testInteger192Bit() {
        var i = Integer192Bit(zeroed: true)
        XCTAssert(i.byteRepresentation == [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        i.increment()
        XCTAssert(i.byteRepresentation == [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        
        for _ in 0..<254 {
            i.increment()
        }
        XCTAssert(i.byteRepresentation == [255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        
        i.increment()
        XCTAssert(i.byteRepresentation == [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        for _ in 0..<255 {
            i.increment()
        }
        XCTAssert(i.byteRepresentation == [255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        
        i.increment()
        XCTAssert(i.byteRepresentation == [0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        
    }
}
#if ATBUILD
extension IncrementTestsTests : XCTestCaseProvider {
        var allTests : [(String, () -> Void)] {
            return [
                ("testInteger192Bit", testInteger192Bit)
            ]
        }
}
#endif