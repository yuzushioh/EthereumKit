//
//  Etherscan.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/19.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import APIKit

public final class Etherscan {
    public struct GetTransactions: EtherscanRequest {
        public typealias Response = Any
        
        public enum Sort: String {
            case asc, des
        }
        
        public let address: Address
        public let sort: Sort
        public let startBlock: Int64
        public let endBlock: Int64
        
        public init(address: Address, sort: Sort = .asc, startBlock: Int64 = 0, endBlock: Int64 = 99999999) {
            self.address = address
            self.sort = sort
            self.startBlock = startBlock
            self.endBlock = endBlock
        }
        
        public var parameters: Any? {
            return [
                "module": "account",
                "action": "txlist",
                "address": address,
                "startblock": NSNumber(value: startBlock),
                "endblock": NSNumber(value: endBlock),
                "sort": sort.rawValue
            ]
        }
    }
}
