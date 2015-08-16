//
//  KeyTests.swift
//  SwiftSodium
//
//  Created by Drew Crawford on 8/15/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation
import XCTest
@testable import NaOH

class KeyTests : XCTestCase {
func testKey() {
    let k = try! Key(password: "My password", salt: "My salt is 32 characters   sjej")
        XCTAssert(k.hash == "C2D877E295C0070384F1486F18CE136C72B050EFAB71D2830260F2A062B9E2AC")
    }
}