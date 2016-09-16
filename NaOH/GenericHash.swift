//
//  GenericHash.swift
//  NaOH
//
//  Created by Drew Crawford on 12/12/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//

import Foundation

@available(iOS 9.3, *, *)
extension Array {
    public var genericHash: [UInt8] {
        get {
            precondition(Element.self == UInt8.self, "genericHash is only implemented for type UInt8, not \(Element.self)") //I'm not sure this works for other arrays
            //sadly, we can't extend a particular one until Swift 3
            var out = [UInt8](repeating: 0, count: Int(crypto_generichash_BYTES))
            self.withUnsafeBufferPointer { (ptr) -> () in
                let cast = UnsafeRawPointer(ptr.baseAddress)!.assumingMemoryBound(to: UInt8.self)
                crypto_generichash(&out, out.count, cast, UInt64(ptr.count), nil, 0)
            }
            return out
        }
    }
}
