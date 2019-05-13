//
//  Transaction.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Transaction: Codable, Param {
    public let version: Number
    public let deps: [OutPoint]
    public let inputs: [CellInput]
    public let outputs: [CellOutput]
    public let witnesses: [Witness]
    public let hash: H256

    public init(
        version: Number = "0",
        deps: [OutPoint] = [],
        inputs: [CellInput] = [],
        outputs: [CellOutput] = [],
        witnesses: [Witness] = [],
        hash: H256 = ""
    ) {
        self.version = version
        self.deps = deps
        self.inputs = inputs
        self.outputs = outputs
        self.witnesses = witnesses
        self.hash = hash
    }

    public var param: [String: Any] {
        return [
            "version": version,
            "deps": deps.map { $0.param },
            "inputs": inputs.map { $0.param },
            "outputs": outputs.map { $0.param },
            "witnesses": witnesses.map { $0.param }
        ]
    }
}

public struct TxStatus: Codable {
    public enum Status: String, Codable {
        case pending
        case proposed
        case committed
    }

    public let status: Status
    public let blockHash: H256?

    enum CodingKeys: String, CodingKey {
        case status
        case blockHash = "block_hash"
    }
}

public struct TransactionWithStatus: Codable {
    public let transaction: Transaction
    public let txStatus: TxStatus

    enum CodingKeys: String, CodingKey {
        case transaction
        case txStatus = "tx_status"
    }
}
