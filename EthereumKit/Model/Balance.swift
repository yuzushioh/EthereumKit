//
//  Balance.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public struct Balance {
    public let wei: UInt64
    
    public var ether: Double {
        return Double(wei) / Double(1000000000000000000)
    }
}
