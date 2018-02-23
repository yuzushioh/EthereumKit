//
//  Transaction.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/20.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation
import SMP

public struct Transaction: Decodable {
    public let blockHash: String
    public let blockNumber: String
    public let hash: String
    public let input: String
    public let confirmations: String
    public let nonce: String
    public let timeStamp: String
    public let contractAddress: Address
    public let from: Address
    public let to: Address
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
