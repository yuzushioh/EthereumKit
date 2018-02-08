//
//  Network.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/01/24.
//  Copyright © 2018 yuzushioh.
//

public enum Network {
    case main
    case test
    
    // https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    var coinType: UInt32 {
        switch self {
        case .main:
            return 60
        case .test:
            return 1
        }
    }
}
