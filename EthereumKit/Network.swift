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
    public var coinType: UInt32 {
        switch self {
        case .main:
            return 60
        case .test:
            return 1
        }
    }
    
    public var privateKeyPrefix: UInt32 {
        switch self {
        case .main:
            return 0x0488ADE4
        case .test:
            return 0x04358394
        }
    }
    
    public var baseURL: URL {
        switch self {
        case .main:
            return Endpoint.mainnet.url
        case .test:
            return Endpoint.ropsten.url
        }
    }
}

public enum Endpoint {
    case mainnet, ropsten
    
    var url: URL {
        switch self {
        case .mainnet:
            return URL(string: "https://mainnet.infura.io/z1sEfnzz0LLMsdYMX4PV")!
        case .ropsten:
            return URL(string: "https://ropsten.infura.io/z1sEfnzz0LLMsdYMX4PV")!
        }
    }
}
