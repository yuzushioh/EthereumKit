//
//  NetworkEnvironment.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/19.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public struct NetworkEnvironment {
    
    private let network: Network
    
    public init(network: Network) {
        self.network = network
    }
    
    public var infuraURL: URL {
        return Endpoint(network: network).infuraURL
    }
    
    public var etherscanURL: URL {
        return Endpoint(network: network).etherscanURL
    }
    
    public var chainID: UInt64 {
        switch network {
        case .main: return 1
        case .test: return 3
        }
    }
}

public enum Endpoint {
    case mainnet, ropsten
    
    public init(network: Network) {
        switch network {
        case .main: self = .mainnet
        case .test: self = .ropsten
        }
    }
    
    public var infuraURL: URL {
        switch self {
        case .mainnet: return URL(string: "https://mainnet.infura.io/z1sEfnzz0LLMsdYMX4PV")!
        case .ropsten: return URL(string: "https://ropsten.infura.io/z1sEfnzz0LLMsdYMX4PV")!
        }
    }
    
    public var etherscanURL: URL {
        switch self {
        case .mainnet: return URL(string: "https://etherscan.io")!
        case .ropsten: return URL(string: "https://ropsten.etherscan.io")!
        }
    }
}
