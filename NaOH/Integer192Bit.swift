//
//  Integer192Bit.swift
//  NaOH
//
//  Created by Drew Crawford on 12/13/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.
#if ATBUILD
    import CSodium
#endif
import Foundation

public struct Integer192Bit {
    public var byteRepresentation: [UInt8]
    
    public init(zeroed: Bool) {
        precondition(24 == crypto_box_NONCEBYTES)
        precondition(24 == crypto_secretbox_NONCEBYTES)
        byteRepresentation = [UInt8](repeating: 0, count: 24)
    }
    
    public init(random: Bool) {
        precondition(24 == crypto_box_NONCEBYTES)
        precondition(24 == crypto_secretbox_NONCEBYTES)
        byteRepresentation = sodium_random(24)
    }
    
    public init(array: [UInt8]) {
        precondition(24 == crypto_box_NONCEBYTES)
        precondition(24 == crypto_secretbox_NONCEBYTES)
        precondition(array.count == 24)
        self.byteRepresentation = array
    }
    
    public mutating func increment() {
        byteRepresentation.constantTimeIncrement()
    }
}