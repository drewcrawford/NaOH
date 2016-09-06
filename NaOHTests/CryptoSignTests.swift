//
//  CryptoSignTests.swift
//  NaOH
//
//  Created by Drew Crawford on 3/30/16.
//  Copyright © 2016 DrewCrawfordApps. All rights reserved.
//

import Foundation
import CarolineCore
@testable import NaOH

private func signingKey() -> CryptoSigningSecretKey {
    #if ATBUILD
        var signingPath = "NaOHTests/signing.key"
    #else
        var signingPath = Bundle(for: CarolineEngineTests.self).path(forResource: "signing", ofType: "key")!
    #endif
    //fix the permsisions on this key so we don't freak out the security goalie
    //on iOS 9.3+, we can't edit the permissions of a file in our app bundle.  Therefore, we have to copy them to a temporary path so the permissions are valid.
    #if !os(Linux)
        //copy item at path is unimplimented on Linux, but this feature isn't technically required there.
        let newAlicePath = NSTemporaryDirectory() + "/signing.key"
        let _ = try? FileManager.`default`.removeItem(atPath: newAlicePath)
        try! FileManager.`default`.copyItem(atPath: signingPath, toPath: newAlicePath)
        signingPath = newAlicePath
    #endif
    try! FileManager.`default`.setSWIFTBUGAttributes([FileAttributeKey.posixPermissions.rawValue: NSNumber(value: 0o0600 as UInt16)], ofItemAtPath: signingPath)
    return try! CryptoSigningSecretKey(readFromFile: signingPath)
}

class GenerateKey: CarolineTest {
    func test() {
        let tempPath = NSTemporaryDirectory() + "signing.key"
        let _  = try? FileManager.`default`.removeItem(atPath: tempPath)
        let key = CryptoSigningSecretKey()
        try! key.saveToFile(tempPath)
        let key2 = try! CryptoSigningSecretKey(readFromFile: tempPath)
        self.assert(key.keyImpl__.hash, equals: key2.keyImpl__.hash)
        self.assert(key.publicKey.bytes, equals: key2.publicKey.bytes)
    }
}

class DeriveKey: CarolineTest {
    func test() {
        let key = signingKey()
        let publicKey = key.publicKey
        self.assert(publicKey.bytes, equals: [108, 24, 241, 240, 92, 36, 168, 1, 222, 148, 14, 236, 102, 246, 91, 139, 120, 223, 234, 172, 217, 119, 203, 48, 46, 137, 55, 107, 233, 167, 55, 93])
    }
}

class TestSign: CarolineTest {
    func test() {
        let key = signingKey()
        let signature = crypto_sign_detached(testMessage, key: key)
        print(signature)
        self.assert(signature, equals: expectedSignature)
    }
}

class TestVerify: CarolineTest {
    func test() {
        let key = signingKey()
        let _ = try! crypto_sign_verify_detached(signature: expectedSignature, message: testMessage, key: key.publicKey )
    }
}

class TestBadVerify: CarolineTest {
    func test() {
        let key = signingKey()
        do {
            let _ = try crypto_sign_verify_detached(signature: expectedSignature, message: [0,1,2,3,4,5,6,7,9], key: key.publicKey )
            self.fail("Verification succeeded.")
        }
        catch NaOHError.CryptoSignError { /* */ }
        catch {
            self.fail("Unknown error.")
        }
    }
}




private let testMessage :[UInt8] = [0,1,2,3,4,5,6,7,8]
private let expectedSignature :[UInt8] = [4, 244, 70, 136, 33, 148, 129, 144, 162, 31, 77, 0, 108, 2, 212, 156, 146, 10, 4, 210, 53, 100, 124, 2, 109, 49, 43, 19, 122, 38, 163, 140, 93, 73, 38, 110, 20, 114, 206, 69, 33, 228, 14, 216, 85, 62, 186, 88, 230, 241, 229, 103, 55, 224, 57, 143, 55, 73, 20, 93, 233, 71, 241, 8]

