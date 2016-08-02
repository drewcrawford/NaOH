//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found in the top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation

@available(iOS 9.3, *, *)
public struct CryptoSigningSecretKey: SecretKey  {
    public let keyImpl_: KeyImplProtocol_
    public let publicKey: CryptoSigningPublicKey
    public init() {
        let localKeyImpl = KeyImpl(uninitializedSize: crypto_sign_secretkeybytes())
        defer { try! localKeyImpl.lock() }
        self.keyImpl_ = localKeyImpl
        var publicKeyBytes = [UInt8](repeating: 0, count: Int(crypto_sign_publickeybytes()))
        
        #if swift(>=3.0)
        publicKeyBytes.withUnsafeMutableBufferPointer { (ptr: inout UnsafeMutableBufferPointer<UInt8>) -> () in
            if crypto_sign_keypair(ptr.baseAddress, localKeyImpl.addr) != 0 {
                preconditionFailure("Can't generate keypair")
            }
        }
        #else
        publicKeyBytes.withUnsafeMutableBufferPointer { (inout ptr:  UnsafeMutableBufferPointer<UInt8>) -> () in
            if crypto_sign_keypair(ptr.baseAddress, localKeyImpl.addr) != 0 {
                preconditionFailure("Can't generate keypair")
            }
        }
        #endif
        
        self.publicKey = CryptoSigningPublicKey(bytes: publicKeyBytes)
    }
    public func saveToFile(_ file: String) throws {
        try self._saveToFile(file, userData: publicKey.bytes)
    }
    public init(readFromFile file: String) throws {
        var userData: [UInt8] = []
        self.keyImpl_ = try KeyImpl(readFromFile: file, userDataBytes: crypto_sign_publickeybytes(), userData: &userData)
        precondition(userData.count == crypto_sign_publickeybytes())
        self.publicKey = CryptoSigningPublicKey(bytes: userData)
        precondition(self.keyImpl__.size == crypto_sign_secretkeybytes())
    }
}

@available(iOS 9.3, *, *)
public struct CryptoSigningPublicKey: PublicKey {
    public let bytes: [UInt8]
    public init(humanReadableString: String) {
        #if swift(>=3.0)
            let options = NSData.Base64DecodingOptions()
        #else
            let options = NSDataBase64DecodingOptions()
        #endif
        let data = NSData(base64Encoded: humanReadableString, options: options)!
        var array = [UInt8](repeating: 0, count: data.length)
        data.getBytes(&array,length:data.length)
        self.init(bytes: array)
    }
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
}

@available(iOS 9.3, *, *)
public func crypto_sign_detached(_ message: [UInt8], key: CryptoSigningSecretKey) -> [UInt8] {
    var sig = [UInt8](repeating: 0, count: Int(crypto_sign_bytes()))
    try! key.keyImpl__.unlock()
    defer { try! key.keyImpl__.lock() }
    let result = crypto_sign_detached(&sig, UnsafeMutablePointer(nil), message, UInt64(message.count), key.keyImpl__.addr)
    precondition(result == 0)
    return sig
}

@available(iOS 9.3, *, *)
public func crypto_sign_verify_detached(signature signature: [UInt8], message: [UInt8], key: CryptoSigningPublicKey) throws {
    precondition(key.bytes.count == Int(crypto_sign_PUBLICKEYBYTES))
    let result = crypto_sign_verify_detached(signature, message, UInt64(message.count), key.bytes)
    if result != 0 { throw NaOHError.CryptoSignError }
}
