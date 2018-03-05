//
//  SignTransaction.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/03/02.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import SMP

public struct SignTransaction {
    public let value: BInt
    public let to: Address
    public let gasPrice: BInt
    public let gasLimit: BInt
    public let data: Data
    public let nonce: Int
    public let chainID: Int
}
