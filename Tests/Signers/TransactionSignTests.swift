//
//  TransactionSignTests.swift
//  CKBTests
//
//  Created by James Chen on 2019/05/16.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class TransactionSignTests: XCTestCase {
    func testSign() throws {
        let tx = Transaction(
            version: "0",
            deps: [
                OutPoint(blockHash: nil, cell: CellOutPoint(txHash: "0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a", index: "1"))
            ],
            inputs: [
                CellInput(
                    previousOutput: OutPoint(blockHash: nil, cell: CellOutPoint(txHash: "0xa80a8e01d45b10e1cbc8a2557c62ba40edbdc36cd63a31fc717006ca7b157b50", index: "0")),
                    since: "0"
                )
            ],
            outputs: [
                CellOutput(
                    capacity: "100000000000",
                    data: "0x",
                    lock: Script(args: ["0xe2193df51d78411601796b35b17b4f8f2cd85bd0"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                ),
                CellOutput(
                    capacity: "4900000000000",
                    data: "0x",
                    lock: Script(args: ["0x36c329ed630d6ce750712a477543672adab57f4c"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                )
            ],
            witnesses: [
                Witness(data: [])
            ]
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let txHash = "0xac1bb95455cdfb89b6e977568744e09b6b80e08cab9477936a09c4ca07f5b8ab"
        let signed = try Transaction.sign(tx: tx, with: privateKey, txHash: txHash)
        XCTAssertEqual(signed.hash, txHash)
        XCTAssertEqual(signed.witnesses.count, tx.inputs.count)
        XCTAssertEqual(
            signed.witnesses.first!.data,
            [
                "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01",
                "0x304402202c643579e47045be050d3842ed9270151af8885e33954bddad0e53e81d1c2dbe02202dc637877a8302110846ebc6a16d9148c106e25f945063ad1c4d4db2b6952408"
            ]
        )
    }

    func testMultipleInputsSign() throws {
        let tx = Transaction(
            version: "0",
            deps: [
                OutPoint(blockHash: "0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb")
            ],
            inputs: [
                CellInput(
                    previousOutput: OutPoint(blockHash: "0x23abf65800d048ed9e3eb67e0258e0d616148e9cb1116ceee532a202b4c30e09", cell: CellOutPoint(txHash: "0x91fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd4", index: "0")),
                    since: "113"
                ),
                CellInput(
                    previousOutput: OutPoint(cell: CellOutPoint(txHash: "0x00000000000000000000000000004e4552564f5344414f494e50555430303031", index: "0")),
                    since: "0"
                )
            ],
            outputs: [
                CellOutput(
                    capacity: "10000009045634",
                    data: "0x",
                    lock: Script(args: ["0x36c329ed630d6ce750712a477543672adab57f4c"], codeHash: "0xf1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd"),
                    type: nil
                )
            ],
            witnesses: [
                Witness(data: ["0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb"]),
                Witness(data: [])
            ]
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let txHash = "0x985772e541c23d4e7dbf9844a9b9d93fcdc62273fa1f4ae1ae82703962dc1a4e"
        let signed = try Transaction.sign(tx: tx, with: privateKey, txHash: txHash)
        XCTAssertEqual(signed.hash, txHash)
        XCTAssertEqual(signed.witnesses.count, tx.inputs.count)
        XCTAssertEqual(
            signed.witnesses.first!.data,
            [
                "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01",
                "0x3044022068a57373f4e98aecfb9501ec1cc4a78c048361332e4b6706bdc1469d30bd52ea022042feca657dd1de1eff384e6ed24a6910b011d49d855bd1ed209f5ce77d8116ac",
                "0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb"
            ]
        )
        XCTAssertEqual(
            signed.witnesses[1].data,
            [
                "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01",
                "0x304402203b13c362f254e7becb0e731e4756e742bfddbf2f5d7c16cd609ba127d2b7e07f02201d588c3a7132fc20c478e2de14f6370fbb9e4402d240e4b32c8d671177e1f311"
            ]
        )
    }

    func testThrowErrorWhenWitnessesUnsatisfied() {
        let tx = Transaction(
            version: "0",
            deps: [
                OutPoint(blockHash: nil, cell: CellOutPoint(txHash: "0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a", index: "1"))
            ],
            inputs: [
                CellInput(
                    previousOutput: OutPoint(blockHash: nil, cell: CellOutPoint(txHash: "0xa80a8e01d45b10e1cbc8a2557c62ba40edbdc36cd63a31fc717006ca7b157b50", index: "0")),
                    since: "0"
                )
            ],
            outputs: [
                CellOutput(
                    capacity: "100000000000",
                    data: "0x",
                    lock: Script(args: ["0xe2193df51d78411601796b35b17b4f8f2cd85bd0"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                ),
                CellOutput(
                    capacity: "4900000000000",
                    data: "0x",
                    lock: Script(args: ["0x36c329ed630d6ce750712a477543672adab57f4c"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                )
            ],
            witnesses: []
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let txHash = "0xac1bb95455cdfb89b6e977568744e09b6b80e08cab9477936a09c4ca07f5b8ab"
        XCTAssertThrowsError(try Transaction.sign(tx: tx, with: privateKey, txHash: txHash)) { error in
            XCTAssertEqual(error.localizedDescription, Transaction.Error.invalidNumberOfWitnesses.localizedDescription)
        }
    }
}
