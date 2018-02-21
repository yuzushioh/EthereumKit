//
//  RPC.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import JSONRPCKit

public final class RPC {
    public struct GetBalance: Request {
        public typealias Response = Balance
        
        public let address: Address
        public let blockParameter: BlockParameter
        
        public var method: String {
            return "eth_getBalance"
        }
        
        public var parameters: Any? {
            return [address, blockParameter.rawValue]
        }
        
        public func response(from resultObject: Any) throws -> Response {
            guard let response = resultObject as? String, let wei = UInt64(response.dropFirst(2), radix:16) else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return Balance(wei: wei)
        }
    }
    
    public struct GetTransactionCount: Request {
        public typealias Response = UInt64
        
        public let address: Address
        public let blockParameter: BlockParameter
        
        public var method: String {
            return "eth_getTransactionCount"
        }
        
        public var parameters: Any? {
            return [address, blockParameter.rawValue]
        }
        
        public func response(from resultObject: Any) throws -> Response {
            guard let response = resultObject as? String, let count = UInt64(response.dropFirst(2), radix: 16) else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return count
        }
    }
}
