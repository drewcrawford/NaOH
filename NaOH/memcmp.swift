//
//  memcmp.swift
//  NaOH
//
//  Created by Drew Crawford on 10/4/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation
#if SWIFT_PACKAGE_MANAGER
import CSodium
#endif

/**Constant time memory comparison of arrays for cryptographic purposes
- warning: Note that this is only constant time for constant-sized inputs.*/
@warn_unused_result
public func sodium_memcmp(a: [UInt8], _ b: [UInt8]) -> Bool {
    let lengthMatches = a.count == b.count
    //we actually continue to evaluate regardless of whether the length matches or not
    //this is so we get a constant time execution
    let shortestSize = min(a.count, b.count)
    let dataMatches = a.withUnsafeBufferPointer { (aPtr) -> Bool in
        b.withUnsafeBufferPointer({ (bPtr) -> Bool in
            return sodium_memcmp(aPtr.baseAddress, bPtr.baseAddress, shortestSize) == 0
        })
    }
    return lengthMatches && dataMatches
}