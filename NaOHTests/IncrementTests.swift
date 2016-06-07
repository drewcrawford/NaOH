//
//  IncrementTests.swift
//  NaOH
//
//  Created by Drew Crawford on 12/13/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation
import CarolineCore
@testable import NaOH

class Integer192BitTests: CarolineTest {
    func test() {
        var i = Integer192Bit(zeroed: true)
        self.assert(i.byteRepresentation,equals: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        i.increment()
        self.assert(i.byteRepresentation, equals: [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        
        for _ in 0..<254 {
            i.increment()
        }
        self.assert(i.byteRepresentation, equals: [255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        
        i.increment()
        self.assert(i.byteRepresentation, equals: [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        for _ in 0..<255 {
            i.increment()
        }
        self.assert(i.byteRepresentation, equals: [255,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        
        i.increment()
        self.assert(i.byteRepresentation, equals: [0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    }
}