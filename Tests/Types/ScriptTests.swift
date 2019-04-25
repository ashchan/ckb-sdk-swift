//
//  ScriptTests.swift
//  CKBTests
//
//  Created by James Chen on 2018/12/26.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class ScriptTests: XCTestCase {
    func testEmptyScriptTypeHash() throws {
        let script = Script()
        XCTAssertEqual("0x266cec97cbede2cfbce73666f08deed9560bdf7841a7a5a51b3a3f09da249e21", script.typeHash)
    }

    func testScriptTypeHash() throws {
        let script = Script(
            args: ["0x01"],
            codeHash: H256.zeroHash
        )
        XCTAssertEqual("0xdade0e507e27e2a5995cf39c8cf454b6e70fa80d03c1187db7a4cb2c9eab79da", script.typeHash)
    }
}
