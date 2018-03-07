//
//  Transaction.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/20.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import SMP

public struct RawTransaction {
    public let value: BInt
    public let to: Address
    public let nonce: Int
    
    public static func create(value: String, address: String, nonce: Int) -> RawTransaction {
        return RawTransaction(value: value, address: address, nonce: nonce)
    }
    
    internal init(value: String, address: String, nonce: Int) {
        self.value = BInt(value)!
        self.to = Address(string: address)
        self.nonce = nonce
    }
}

public struct SignTransaction {
    public let value: BInt
    public let to: Address
    public let nonce: Int
    public let gasPrice: Int
    public let gasLimit: Int
    public let data: Data
    
    public init(rawTransaction: RawTransaction, gasPrice: Int, gasLimit: Int, data: Data = Data()) {
        self.value = rawTransaction.value
        self.to = rawTransaction.to
        self.nonce = rawTransaction.nonce
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.data = data
    }
}

public struct SentTransaction {
    public let id: String
}

public struct Transaction: Decodable {
    public let blockHash: String
    public let blockNumber: String
    public let hash: String
    public let input: String
    public let confirmations: String
    public let nonce: String
    public let timeStamp: String
    public let contractAddress: String
    public let from: String
    public let to: String
    public let gas: String
    public let gasPrice: String
    public let gasUsed: String
    public let cumulativeGasUsed: String
    public let isError: String
    public let transactionIndex: String
    public let txreceipt_status: String
    public let value: String
    
    public var balance: Balance {
        return Balance(wei: BInt(number: value, withBase: 10)!)
    }
}

public struct Transactions: Decodable {
    public let elements: [Transaction]
    
    enum CodingKeys: String, CodingKey {
        case elements = "result"
    }
}

extension RawTransaction {
//    internal init(value: BInt, address: String, nonce: Int) {
//        self.value = value
//        self.to = Address(string: address)
//        self.nonce = nonce
//    }
}

extension SignTransaction {
    internal init(value: BInt, to: Address, nonce: Int, gasPrice: Int, gasLimit: Int, data: Data) {
        self.value = value
        self.to = to
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.data = data
    }
}
