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


extension SecretKey {
    /**Saves the key to the file indicated.
- note: This function ensures that the key is saved to a file only readable by the user.
- warning: Using the keychain is probably better, but it isn't appropriate for certain applications.
*/
    public func saveToFile(file: String) throws {
        if NSFileManager.defaultManager().fileExists(atPath: file) {
            throw NaOHError.WontOverwriteKey
        }
        //create a locked down file
        //so that we only write if everything's good
        try NSData().write(toFile: file, options: NSDataWritingOptions())
        try NSFileManager.defaultManager().setSWIFTBUGAttributes([NSFilePosixPermissions: NSNumber(short: 0o0600)], ofItemAtPath: file)
        
        //with that out of the way
        try self.keyImpl__.unlock()
        defer { try! self.keyImpl__.lock() }
        let data = NSData(bytesNoCopy: self.keyImpl__.addrAsVoid, length: keyImpl__.size, freeWhenDone: false)
        try data.write(toFile: file, options: NSDataWritingOptions())
    }
    
}