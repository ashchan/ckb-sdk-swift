//
//  Blake2b.swift
//  CKB
//
//  Created by James Chen on 2019/03/06.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import Sodium
import Clibsodium

// Blake2b-256 Hash, with CKB's personalization.
final class Blake2b {
    static let hashPersonalization = "ckb-default-hash"

    func hash(data: Data) -> Data? {
        return hash(bytes: data.bytes)
    }

    func hash(bytes: [UInt8]) -> Data? {
        let outputLength = Int(crypto_generichash_bytes())
        var output = [UInt8](repeating: 0, count: outputLength)
        let personal = [UInt8](Blake2b.hashPersonalization.utf8)

        guard 0 == crypto_generichash_blake2b_salt_personal(
            &output,
            outputLength,
            bytes,
            UInt64(bytes.count),
            nil,
            0,
            nil,
            personal
        ) else { return nil }

        return Data(bytes: output)
    }
}
