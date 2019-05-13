//
//  OutPoint.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct OutPoint: Codable, Param {
    public let blockHash: H256?
    public let cell: CellOutPoint?

    enum CodingKeys: String, CodingKey {
        case blockHash = "block_hash"
        case cell
    }

    public init(blockHash: H256, cell: CellOutPoint) {
        self.blockHash = blockHash
        self.cell = cell
    }

    public var param: [String: Any] {
        var result = [String: Any]()
        if let blockHash = blockHash {
            result["block_hash"] = blockHash
        }
        if let cell = cell {
            result["cell"] = cell
        }
        return result
    }
}

public struct CellOutPoint: Codable, Param {
    public let txHash: H256
    public let index: Number

    enum CodingKeys: String, CodingKey {
        case txHash = "tx_hash"
        case index
    }

    public init(txHash: H256, index: Number) {
        self.txHash = txHash
        self.index = index
    }

    public var param: [String: Any] {
        return [
            "tx_hash": txHash,
            "index": index
        ]
    }
}
