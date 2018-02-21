//
//  Balance.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

public struct Balance {
    public let wei: BInt
    
    public var ether: BDouble {
        return BDouble(wei, over: BInt(number: "1000000000000000000", withBase: 10))
    }
}
