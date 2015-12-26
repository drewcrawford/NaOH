//
//  increment.swift
//  NaOH
//
//  Created by Drew Crawford on 12/13/15.
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

extension Array {
    /**Increments an array of UInt8 (interpreted as an arbitrarily-long unsigned number) in a way resistant to timing attacks. */
    mutating func constantTimeIncrement() {
        //fix this in Swift 3?
        precondition(Element.self == UInt8.self, "Unexpected element \(Element.self); only implemented for UInt8")
        withUnsafeMutableBufferPointer { (ptr) -> () in
            let convertedPtr: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(ptr.baseAddress)
            sodium_increment(convertedPtr, ptr.count)
        }
    }
}
