//
//  SecretKey.swift
//  NaOH
//
//  Created by Drew Crawford on 3/30/16.
//  Copyright © 2016 DrewCrawfordApps. All rights reserved.
//

import Foundation
/**- warning: This is a private API.  If you find yourself setting it from outside NaOH, think again. */
@available(iOS 9.3, *)
public protocol KeyImplProtocol_ {}
@available(iOS 9.3, *)
extension KeyImpl : KeyImplProtocol_ { }
@available(iOS 9.3, *)
internal extension SecretKey {
    var keyImpl__ : KeyImpl { return keyImpl_ as! KeyImpl }
}
/** A secret key.
- warning: This protocol is not intended to be conformed to by implementations outside of NaOH.  If you find yourself doing that, think again. */
@available(iOS 9.3, *)
public protocol SecretKey : CustomStringConvertible {
    /**- warning: This is a private API.  If you find yourself setting it from outside NaOH, think again. */
    var keyImpl_: KeyImplProtocol_ { get }
    
    ///A default implementation of this is provided, but can be overridden for custom behavior
    func saveToFile(_ file: String) throws
}
@available(iOS 9.3, *)
extension SecretKey {
    public var description: String { return keyImpl__.description }
}

