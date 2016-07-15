// Copyright (c) 2016 Drew Crawford.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest
import CarolineCore
@testable import NaOHiOSTestHostAppTests

class CarolineEngineTests: XCTestCase {
    func testAllCarolineTests() {
        let allTests: [CarolineTest] = [
            ChaCha20(),
            KeyTest(),
            ZeroImport(),
            Crypto(),
            OverwriteKey(),
            CryptoBoxKey(),
            HumanReadable(),
            KeyLoadSave(),
            PublicKeyLoadSave(),
            EncryptTest(),
            DecryptTest(),
            BadDecrypt(),
            Integer192BitTests(),
            CryptoBox(),
            CryptoBoxOpen(),
            GenerateKey(),
            DeriveKey(),
            TestSign(),
            TestVerify(),
            TestBadVerify(),
            GenericHash(),
            MemCmpTest()
        ]
        let engine = CarolineCoreEngine()
        if !engine.testAll(allTests) {
            XCTFail("Caroline tests failed")
        }
    }
}
