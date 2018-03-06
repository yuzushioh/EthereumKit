//
//  JSONRPC.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import JSONRPCKit
import SMP

public final class JSONRPC {
    public struct GetBalance: Request {
        public typealias Response = Balance
        
        public let address: Address
        public let blockParameter: BlockParameter
        
        public var method: String {
            return "eth_getBalance"
        }
        
        public var parameters: Any? {
            return [address.string, blockParameter.rawValue]
        }
        
        public func response(from resultObject: Any) throws -> Balance {
            guard let response = resultObject as? String, let wei = BInt(response.hex.lowercased(), radix: 16) else {
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
            return [address.string, blockParameter.rawValue]
        }
        
        public func response(from resultObject: Any) throws -> Response {
            guard let response = resultObject as? String, let count = UInt64(response.hex, radix: 16) else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return count
        }
    }
    
    public struct SendRawTransaction: Request {
        public typealias Response = SentTransaction
        
        public let rawTransaction: String
        
        public var method: String {
            return "eth_sendRawTransaction"
        }
        
        public var parameters: Any? {
            return [rawTransaction]
        }
        
        public func response(from resultObject: Any) throws -> Response {
            guard let transactionID = resultObject as? String else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return Response(id: transactionID)
        }
    }
}
