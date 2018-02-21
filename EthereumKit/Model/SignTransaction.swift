//
//  SignTransaction.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/20.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public struct SignTransaction {
    public let value: UInt64
    public let account: Account
    public let address: Address
    public let nonce: Int
    public let data: Data
    public let gasPrice: UInt64
    public let gasLimit: UInt64
    public let chainID: Int
}
