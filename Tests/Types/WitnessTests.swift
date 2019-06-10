//
//  WitnessTests.swift
//  CKBTests
//
//  Created by James Chen on 2019/06/05.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class WitnessTests: XCTestCase {
    func testParam() {
        let witness = Witness(data: ["0xab", "0xcd"])
        XCTAssertEqual(witness.param["data"] as! [String], ["0xab", "0xcd"])
    }
}
