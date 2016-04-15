//
//  Key+Zeroing.swift
//  NaOH
//
//  Created by Drew Crawford on 8/16/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found inthe top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  inthe LICENSE file.

import Foundation
@available(iOS 9.3, *)
extension KeyImpl {
    /**Creates a key from the existing memory, importing it into the NaOH memory system and zeroing out the source */
    #if swift(>=3.0)
    convenience init (zeroingMemory: inout [UInt8]) {
        self.init(uninitializedSize: zeroingMemory.count)
        #if swift(>=3.0)
        zeroingMemory.withUnsafeMutableBufferPointer { (ptr:inout UnsafeMutableBufferPointer<UInt8>) -> () in
            memcpy(addrAsVoid, ptr.baseAddress!, ptr.count)
            sodium_memzero(ptr.baseAddress!, ptr.count)
        }
        #else
        zeroingMemory.withUnsafeMutableBufferPointer { (inout ptr: UnsafeMutableBufferPointer<UInt8>) -> () in
            memcpy(addrAsVoid, ptr.baseAddress, ptr.count)
            sodium_memzero(ptr.baseAddress, ptr.count)
        }
        #endif
        try! self.lock()
    }
    #else
    convenience init (inout zeroingMemory: [UInt8]) {
        self.init(uninitializedSize: zeroingMemory.count)
        #if swift(>=3.0)
            zeroingMemory.withUnsafeMutableBufferPointer { (ptr:inout UnsafeMutableBufferPointer<UInt8>) -> () in
            memcpy(addrAsVoid, ptr.baseAddress, ptr.count)
            sodium_memzero(ptr.baseAddress, ptr.count)
            }
        #else
            zeroingMemory.withUnsafeMutableBufferPointer { (inout ptr: UnsafeMutableBufferPointer<UInt8>) -> () in
                memcpy(addrAsVoid, ptr.baseAddress, ptr.count)
                sodium_memzero(ptr.baseAddress, ptr.count)
            }
        #endif
        try! self.lock()
    }
    #endif
}