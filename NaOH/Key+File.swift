//
//  Key+File.swift
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

@available(iOS 9.3, *, *)
extension SecretKey {
    
    /**Saves the key to the file indicated.
     - note: This function ensures that the key is saved to a file only readable by the user.
     - warning: Using the keychain is probably better, but it isn't appropriate for certain applications.
     */
    public func saveToFile(_ file: String) throws {
        try self._saveToFile(file, userData: [])
    }
    
    /**This internal variant allows a custom key to serialize its own data.*/
    func _saveToFile(_ file: String, userData: [UInt8]) throws {
        if NSFileManager.`default`().fileExists(atPath: file) {
            throw NaOHError.WontOverwriteKey
        }
        //create a locked down file
        //so that we only write if everything's good
        try NSData().write(toFile: file, options: NSDataWritingOptions())
        try NSFileManager.`default`().setSWIFTBUGAttributes([NSFilePosixPermissions: NSNumber(value: 0o0600 as UInt16)], ofItemAtPath: file)
        
        //with that out of the way
        try self.keyImpl__.unlock()
        defer { try! self.keyImpl__.lock() }
        
        let data = NSMutableData(bytes: self.keyImpl__.addr, length: self.keyImpl__.size)
        let userNSData = userData.withUnsafeBufferPointer { (ptr) -> NSData in
            return NSData(bytes: ptr.baseAddress, length: ptr.count)
        }
        data.append(userNSData)
        try data.write(toFile: file, options: NSDataWritingOptions())
        //scrub the data
        sodium_memzero(data.mutableBytes, data.length)
    }
    
}