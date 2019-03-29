//
//  CellOutput.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellOutput: Codable, Param {
    public let capacity: Capacity
    public let data: HexString
    public let lock: Script
    public let type: Script?

    public var param: [String: Any] {
        var result: [String: Any] = [
            "capacity": capacity,
            "data": data,
            "lock": lock
        ]
        if let type = type {
            result["type"] = type
        }
        return result
    }
}

public struct CellOutputWithOutPoint: Codable {
    public let outPoint: OutPoint
    public let capacity: Capacity
    public let lock: H256

    enum CodingKeys: String, CodingKey {
        case outPoint = "out_point"
        case capacity, lock
    }
}
