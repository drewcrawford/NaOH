//
//  CryptoSignTests.swift
//  NaOH
//
//  Created by Drew Crawford on 3/30/16.
//  Copyright © 2016 DrewCrawfordApps. All rights reserved.
//

import Foundation
@testable import NaOH
import XCTest

class CryptoSignTests : XCTestCase {
    
    func signingKey() -> CryptoSigningSecretKey {
        #if ATBUILD
            var signingPath = "NaOHTests/signing.key"
        #else
            var signingPath = NSBundle(forClass: CryptoSignTests.self).pathForResource("signing", ofType: "key")!
        #endif
        //fix the permsisions on this key so we don't freak out the security goalie
        //on iOS 9.3+, we can't edit the permissions of a file in our app bundle.  Therefore, we have to copy them to a temporary path so the permissions are valid.
        #if !os(Linux)
            //copy item at path is unimplimented on Linux, but this feature isn't technically required there.
            let newAlicePath = NSTemporaryDirectory() + "/signing.key"
            let _ = try? NSFileManager.defaultManager().removeItem(atPath: newAlicePath)
            try! NSFileManager.defaultManager().copyItem(atPath: signingPath, toPath: newAlicePath)
            signingPath = newAlicePath
        #endif
         try! NSFileManager.defaultManager().setSWIFTBUGAttributes([NSFilePosixPermissions: NSNumber(short: 0o0600)], ofItemAtPath: signingPath)
        return try! CryptoSigningSecretKey(readFromFile: signingPath)
    }
    
    func testGenerateKey() {
        let tempPath = NSTemporaryDirectory() + "signing.key"
        let _  = try? NSFileManager.defaultManager().removeItem(atPath: tempPath)
        let key = CryptoSigningSecretKey()
        try! key.saveToFile(tempPath)
        let key2 = try! CryptoSigningSecretKey(readFromFile: tempPath)
        XCTAssert(key.keyImpl__.hash == key2.keyImpl__.hash)
        XCTAssert(key.publicKey.bytes == key2.publicKey.bytes)
    }
    
    func testDeriveKey() {
        let key = signingKey()
        let publicKey = key.publicKey
        XCTAssert(publicKey.bytes == [108, 24, 241, 240, 92, 36, 168, 1, 222, 148, 14, 236, 102, 246, 91, 139, 120, 223, 234, 172, 217, 119, 203, 48, 46, 137, 55, 107, 233, 167, 55, 93])
    }
    
    private let testMessage :[UInt8] = [0,1,2,3,4,5,6,7,8]
    private let expectedSignature :[UInt8] = [4, 244, 70, 136, 33, 148, 129, 144, 162, 31, 77, 0, 108, 2, 212, 156, 146, 10, 4, 210, 53, 100, 124, 2, 109, 49, 43, 19, 122, 38, 163, 140, 93, 73, 38, 110, 20, 114, 206, 69, 33, 228, 14, 216, 85, 62, 186, 88, 230, 241, 229, 103, 55, 224, 57, 143, 55, 73, 20, 93, 233, 71, 241, 8]
    
    func testSign() {
        let key = signingKey()
        let signature = crypto_sign_detached(testMessage, key: key)
        print(signature)
        XCTAssert(signature == expectedSignature)
    }
    
    func testVerify() {
        let key = signingKey()
        let _ = try! crypto_sign_verify_detached(signature: expectedSignature, message: testMessage, key: key.publicKey )
    }
    
    func testBadVerify() {
        let key = signingKey()
        do {
            let _ = try crypto_sign_verify_detached(signature: expectedSignature, message: [0,1,2,3,4,5,6,7,9], key: key.publicKey )
            XCTFail("Verification succeeded.")
        }
        catch NaOHError.CryptoSignError { /* */ }
        catch {
            XCTFail("Unknown error.")
        }

    }
    
}