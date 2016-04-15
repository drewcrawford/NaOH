//
//  PublicKey.swift
//  NaOH
//
//  Created by Drew Crawford on 8/16/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found inthe top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

@available(iOS 9.3, *, *)
public protocol PublicKey : CustomStringConvertible {
    var bytes : [UInt8] { get }
    
}
@available(iOS 9.3, *, *)
extension PublicKey {
    public var description: String {
        return "<PublicKey: '\(humanReadable)'>"
    }
}

@available(iOS 9.3, *, *)
extension PublicKey {
    public func saveToFile(_ file: String) throws {
        if NSFileManager.defaultManager().fileExists(atPath: file) {
            throw NaOHError.WontOverwriteKey
        }
        
        let data = bytes.withUnsafeBufferPointer { (ptr) -> NSData in
            return NSData(bytes: ptr.baseAddress, length: ptr.count)
        }
        try data.write(toFile: file)
    }
}

@available(iOS 9.3, *, *)
func == (a: PublicKey, b: PublicKey) -> Bool {
    return a.bytes == b.bytes
}

/** Reads the key from the file indicated. */
internal func publicKeyReadFromFile(_ file: String) throws -> [UInt8] {
    let mutableData = try NSMutableData(contentsOfFile: file, options: NSDataReadingOptions())
    var bytes = [UInt8](repeating: 0, count: mutableData.length)
    bytes.withUnsafeMutableBufferPointer { (ptr) -> () in
        #if swift(>=3.0)
            mutableData.getBytes(ptr.baseAddress!, length: ptr.count)
        #else
            mutableData.getBytes(ptr.baseAddress, length: ptr.count)
        #endif
    }
    return bytes
}