//
//  Balance.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation
import SMP

public struct Balance {
    public let wei: Wei
    
    public var ether: Ether {
        return Converter.toEther(wei: wei)
    }
}
