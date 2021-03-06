//
//  Key.swift
//  SwiftSodium
//
//  Created by Drew Crawford on 8/15/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.
import Foundation
/**A secure key storage class.

You should use this because:

1.  It can't be swapped to disk.
2.  There's a guard page making it more difficult for a C-like bug to access this key.
3.  It zeroes the memory upon delete
4.  It can only be read or written to when unlocked by SwiftSodium, not for other purposes.
*/
@available(iOS 9.3, *)
final class KeyImpl {
    let addr : UnsafeMutablePointer<UInt8>
    var addrAsVoid : UnsafeMutableRawPointer {
        get {
            return unsafeBitCast(addr, to: UnsafeMutableRawPointer.self)
        }
    }
    
    let size: Int
    internal init(uninitializedSize: Int) {
        sodium_init_wrap()
        self.size = uninitializedSize
        addr = UnsafeMutablePointer<UInt8>(sodium_malloc(size).bindMemory(to: UInt8.self, capacity: size))
    }
    
    deinit {
        sodium_free(addrAsVoid)
    }
    
    func lock() throws {
        if sodium_mprotect_noaccess(addrAsVoid) != 0 {
            throw NaOHError.ProtectionError
        }
    }
    
    func unlock() throws {
        if sodium_mprotect_readwrite(addrAsVoid) != 0 {
            throw NaOHError.ProtectionError
        }
    }
    
    /**Generates a unique hash of the key */
    var hash: String {
        get {
            try! unlock()
            defer { try! lock() }
            var hash = [UInt8](repeating: 0, count: Int(crypto_generichash_BYTES))
            if crypto_generichash(&hash, hash.count, addr, UInt64(size), nil, 0) != 0 {
                preconditionFailure("Hash error")
            }
            var str = ""
            for char in hash {
                str += NSString(format: "%02X", char).toString
            }
            return str
        }
    }
}

@available(iOS 9.3, *)
extension KeyImpl: CustomStringConvertible {
    var description: String {
        get {
            return "<SwiftSodium.KeyImpl hash: \(hash) >"
        }
    }
}

@available(iOS 9.3, *, *)
public enum KeySizes {
    case crypto_box_seed
    case crypto_stream_chacha20
    case crypto_secretbox
    
    var size: Int {
        get {
            switch(self) {
            case .crypto_box_seed:
                return Int(crypto_box_SEEDBYTES)
            case .crypto_stream_chacha20:
                return Int(crypto_stream_chacha20_KEYBYTES)
            case .crypto_secretbox:
                return Int(crypto_secretbox_KEYBYTES)
            }
        }
    }
}
@available(iOS 9.3, *)
extension KeyImpl {
    convenience init(password: String, salt: String, keySize: Int) throws  {
        sodium_init_wrap()
        let saltBytes = salt.cString(using: String.Encoding.utf8)!
        precondition(saltBytes.count == Int(crypto_pwhash_scryptsalsa208sha256_SALTBYTES), "\(saltBytes.count) is different than \(crypto_pwhash_scryptsalsa208sha256_SALTBYTES)")
        
        var bytes = password.cString(using: String.Encoding.utf8)!
        
        
        self.init(uninitializedSize: keySize)
        let saltPtr = saltBytes.withUnsafeBufferPointer { (saltPtr) -> UnsafePointer<UInt8> in
            return unsafeBitCast(saltPtr.baseAddress, to: UnsafePointer<UInt8>.self)
        }
        
        if crypto_pwhash_scryptsalsa208sha256(addr, UInt64(keySize), &bytes, UInt64(bytes.count - 1), saltPtr, crypto_pwhash_scryptsalsa208sha256_OPSLIMIT_INTERACTIVE, Int(crypto_pwhash_scryptsalsa208sha256_MEMLIMIT_INTERACTIVE)) != 0 {
            throw NaOHError.OOM
        }
        try lock()
    }
    
    /**Generates a random key */
    convenience init(randomSize: Int) {
        sodium_init_wrap()
        self.init(uninitializedSize: randomSize)
        randombytes_buf(self.addrAsVoid, randomSize)
        try! lock()
    }
    
    /** Reads the key from the file indicated.
     - note: This function ensures that the key is read from a file only readable by the user.
     - warning: Using the keychain is probably better, but it isn't appropriate for certain applications. */
    convenience init (readFromFile file: String) throws {
        var data : [UInt8] = []
        try self.init(readFromFile: file, userDataBytes: 0,  userData: &data)
    }
    
    /**Constructs the key from the bytes.
 - note: This zeroes the bytes, therefore they must be mutable
 - warning: We cannot zero other copies of the data that may exist.  Please be careful with key material.*/
    convenience init (bytes: inout [UInt8]) {
        let keySize = bytes.count
        self.init(uninitializedSize: keySize)
        bytes.withUnsafeMutableBytes { (ptr) -> () in
            memcpy(addrAsVoid, ptr.baseAddress!, ptr.count)
            sodium_memzero(ptr.baseAddress!, ptr.count)
        }
        try! self.lock()
    }
    
    /** Reads the key from the file indicated.
     - note: This function ensures that the key is read from a file only readable by the user.
     - warning: Using the keychain is probably better, but it isn't appropriate for certain applications.
     - parameter userDataBytes: Extra user data stored in this file that we don't consider part of the key.  This is returned in the userData parameter.*/
    convenience init (readFromFile file: String, userDataBytes: Int, userData: inout [UInt8]) throws {
        //check attributes
        let attributes = try FileManager.`default`.attributesOfItem(atPath: file)
        #if os(Linux)
        guard let num = attributes[FileAttributeKey.posixPermissions] as? NSNumber else { fatalError("Weird; why isn't \(attributes[FileAttributeKey.posixPermissions]) an NSNumber?") }
        #else
        guard let num = attributes[FileAttributeKey.posixPermissions] as? NSNumber else { fatalError("Weird; why isn't \(attributes[FileAttributeKey.posixPermissions]) an NSNumber?") }
        #endif
        if num.uint16Value != 0o0600 {
            throw NaOHError.FilePermissionsLookSuspicious
        }
        let mutableData = try NSMutableData(contentsOfFile: file, options: [])
        let keySize = mutableData.length - userDataBytes
        self.init(uninitializedSize: keySize)
        memcpy(addrAsVoid, mutableData.bytes, keySize)
        
        var localUserData = [UInt8](repeating: 0, count: userDataBytes)
        localUserData.withUnsafeMutableBufferPointer { (ptr) -> () in
            mutableData.getBytes(ptr.baseAddress!, range: NSRange(location: keySize, length: userDataBytes))
        }
        userData = localUserData
        //zero out the data
        sodium_memzero(mutableData.mutableBytes, mutableData.length)
        try! self.lock()
    }
}
