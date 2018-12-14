//
//  APIRequest.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

/// JSON RPC request object.
public struct APIRequest<R> {
    let method: String
    let params: [Any]
    let decode: (Data) throws -> R?
}

extension APIRequest where R: Codable {
    init(method: String, params: [Any] = []) {
        self.method = method
        self.params = params
        decode = { data in
            let result = try JSONDecoder().decode(APIResult<R>.self, from: data)
            if let error = result.error {
                throw error
            }
            return result.result
        }
    }
}
