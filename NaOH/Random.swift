//
//  Random.swift
//  NaOH
//
//  Created by Drew Crawford on 9/23/15.
//  Copyright © 2015 DrewCrawfordApps. All rights reserved.
//  This file is part of NaOH.  It is subject to the license terms in the LICENSE
//  file found inthe top level of this distribution
//  No part of NaOH, including this file, may be copied, modified,
//  propagated, or distributed except according to the terms contained
//  in the LICENSE file.

import Foundation
@available(iOS 9.3, *)
public func sodium_random(size: Int) -> [UInt8] {
    var buf = [UInt8](repeating: 0, count: size)
    randombytes_buf(&buf, size)
    return buf
}