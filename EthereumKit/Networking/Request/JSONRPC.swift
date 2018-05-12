public final class JSONRPC {
    public struct GetGasPrice: JSONRPCRequest {
        public typealias Response = Wei
        
        public var method: String {
            return "eth_gasPrice"
        }
        
        public func response(from resultObject: Any) throws -> Wei {
            guard let response = resultObject as? String, let wei = Wei(hex: response.lowercased().stripHexPrefix()) else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return wei
        }
    }
    
    public struct GetBalance: JSONRPCRequest {
        public typealias Response = Balance
        
        public let address: String
        public let blockParameter: BlockParameter
        
        public var method: String {
            return "eth_getBalance"
        }
        
        public var parameters: Any? {
            return [address, blockParameter.rawValue]
        }
        
        public func response(from resultObject: Any) throws -> Balance {
            guard let response = resultObject as? String, let wei = Wei(hex: response.lowercased().stripHexPrefix()) else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return Balance(wei: wei)
        }
    }
    
    public struct GetTransactionCount: JSONRPCRequest {
        public typealias Response = Int
        
        public let address: String
        public let blockParameter: BlockParameter
        
        public var method: String {
            return "eth_getTransactionCount"
        }
        
        public var parameters: Any? {
            return [address, blockParameter.rawValue]
        }
        
        public func response(from resultObject: Any) throws -> Response {
            guard let response = resultObject as? String else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return Int(response.stripHexPrefix(), radix: 16) ?? 0
        }
    }
    
    public struct SendRawTransaction: JSONRPCRequest {
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
    
    public struct Call: JSONRPCRequest {
        public typealias Response = String
        
        public let from: String?
        public let to: String
        public let gasLimit: Int?
        public let gasPrice: Int?
        public let value: Int?
        public let data: String?
        public let blockParameter: BlockParameter
        
        public var method: String {
            return "eth_call"
        }
        
        public var parameters: Any? {
            var txParams: [String: Any] = [:]
            
            if let fromAddress = from {
                txParams["from"] = fromAddress
            }
            
            txParams["to"] = to
            
            if let gas = gasLimit {
                txParams["gas"] = gas
            }
            
            if let gasPrice = gasPrice {
                txParams["gasPrice"] = gasPrice
            }
            
            if let value = value {
                txParams["value"] = value
            }
            
            if let data = data {
                txParams["data"] = data
            }

            return [txParams, blockParameter.rawValue]
        }
        
        public func response(from resultObject: Any) throws -> Response {
            guard let response = resultObject as? Response else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return response
        }
    }
    
    public struct GetEstimatGas: JSONRPCRequest {
        public typealias Response = Wei
        
        public let from: String?
        public let to: String
        public let gasLimit: Int?
        public let gasPrice: Int?
        public let value: Int?
        public let data: String?
        
        public var method: String {
            return "eth_estimateGas"
        }
        
        public var parameters: Any? {
            var txParams: [String: Any] = [:]
            
            if let fromAddress = from {
                txParams["from"] = fromAddress
            }
            
            txParams["to"] = to
            
            if let gas = gasLimit {
                txParams["gas"] = gas
            }
            
            if let gasPrice = gasPrice {
                txParams["gasPrice"] = gasPrice
            }
            
            if let value = value {
                txParams["value"] = value
            }
            
            if let data = data {
                txParams["data"] = data
            }
            
            return [txParams]
        }
        
        public func response(from resultObject: Any) throws -> Wei {
            guard let response = resultObject as? String, let wei = Wei(hex: response.lowercased().stripHexPrefix()) else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return wei
        }
    }
    
    public struct GetBlockNumber: JSONRPCRequest {
        public typealias Response = Int
        
        public var method: String {
            return "eth_blockNumber"
        }
        
        public func response(from resultObject: Any) throws -> Int {
            guard let response = resultObject as? String, let blockNumber = Int(response.stripHexPrefix(), radix: 16) else {
                throw JSONRPCError.unexpectedTypeObject(resultObject)
            }
            return blockNumber
        }
    }
}
