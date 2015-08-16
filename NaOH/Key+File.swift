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

extension Key {
    /**Saves the key to the file indicated.
- note: This function ensures that the key is saved to a file only readable by the user.
- warning: Using the keychain is probably better, but it isn't appropriate for certain applications.
*/
    public func saveToFile(file: String) throws {
        //create a locked down file
        //so that we only write if everything's good
        try NSData().writeToFile(file, options: NSDataWritingOptions())
        try NSFileManager.defaultManager().setAttributes([NSFilePosixPermissions: NSNumber(short: 0o0600)], ofItemAtPath: file)
        
        //with that out of the way
        try self.unlock()
        defer { try! self.lock() }
        let data = NSData(bytesNoCopy: self.addrAsVoid, length: size, freeWhenDone: false)
        try data.writeToFile(file, options: NSDataWritingOptions())
    }
    
/** Reads the key from the file indicated.
- note: This function ensures that the key is read from a file only readable by the user.
- warning: Using the keychain is probably better, but it isn't appropriate for certain applications. */
    public convenience init (readFromFile file: String) throws {
        //check attributes
        let attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(file)
        if attributes[NSFilePosixPermissions]?.shortValue != 0o0600 {
            throw NaOHError.FilePermissionsLookSuspicious
        }
        let mutableData = try NSMutableData(contentsOfFile: file, options: NSDataReadingOptions())
        self.init(uninitializedSize: mutableData.length)
        memcpy(addrAsVoid, mutableData.bytes, mutableData.length)
        //zero out the data
        sodium_memzero(mutableData.mutableBytes, mutableData.length)
    }
}

extension PublicKey {
    /**Saves the key to the file indicated.
    - note: This function ensures that the key is saved to a file only readable by the user.
    - warning: Using the keychain is probably better, but it isn't appropriate for certain applications.
    */
    public func saveToFile(file: String) throws {
        try self.secretKey!.saveToFile(file)
    }
    
    /** Reads the key from the file indicated.
    - note: This function ensures that the key is read from a file only readable by the user.
    - warning: Using the keychain is probably better, but it isn't appropriate for certain applications. */
    public convenience init (readFromFile file: String) throws {
        let secretKey = try Key(readFromFile: file)
        self.init(secretKey: secretKey)
    }
}