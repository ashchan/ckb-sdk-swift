//
//  Secp256k1.swift
//  CKB
//
//  Created by James Chen on 2019/03/02.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import secp256k1

/// Thin wrapper of [C Secp256k1 library](https://github.com/bitcoin-core/secp256k1).
final public class Secp256k1 {
    /// Compute the public key for a secret key.
    /// - Parameters:
    ///   - privateKey: The 32-byte private key data.
    ///   - compressed: Specify if the public key should be compressed. Default is true.
    ///
    /// - Returns: The computed public key data. It's 33-byte if `compressed` is true, 65-byte otherwise.
    public static func privateToPublic(privateKey: Data, compressed: Bool = true) -> Data {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(context) }

        let seckeyData = Array(privateKey)
        var publicKey = secp256k1_pubkey()
        _ = secp256k1_ec_pubkey_create(context, &publicKey, seckeyData)

        var length = compressed ? 33 : 65
        var data = Data(count: length)
        data.withUnsafeMutableBytes {
            let flag = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
            let mutableBytes = $0.baseAddress!.assumingMemoryBound(to: UInt8.self)
            _ = secp256k1_ec_pubkey_serialize(context, mutableBytes, &length, &publicKey, flag)
        }
        return data
    }

    /// ECDSA sign message with secret key.
    /// - Parameters:
    ///   - privateKey: The 32-byte private key data.
    ///   - data: The message to sign.
    ///
    /// - Returns: The signed data. If the signing is not successful returns nil.
    public static func sign(privateKey: Data, data: Data) -> Data? {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(context) }

        var signature: secp256k1_ecdsa_signature = secp256k1_ecdsa_signature()
        let result = data.withUnsafeBytes { (data: UnsafeRawBufferPointer) -> Int32 in
            privateKey.withUnsafeBytes { (privateKey: UnsafeRawBufferPointer) in
                withUnsafeMutablePointer(to: &signature, {
                    let dataPointer = data.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    let privateKeyPointer = privateKey.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    return secp256k1_ecdsa_sign(context, $0, dataPointer, privateKeyPointer, nil, nil)
                })
            }
        }
        guard result == 1 else {
            return nil
        }

        return serializeSignature(signature: &signature)
    }

    static func serializeSignature(signature: inout secp256k1_ecdsa_signature) -> Data? {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(context) }

        var length = 74
        var serialized = Data(count: length)
        var result: Int32 = 0
        serialized.withUnsafeMutableBytes {
            let mutableBytes = $0.baseAddress!.assumingMemoryBound(to: UInt8.self)
            result = secp256k1_ecdsa_signature_serialize_der(context, mutableBytes, &length, &signature)
        }
        guard result == 1 else {
            return nil
        }

        return serialized.prefix(length)
    }
}
