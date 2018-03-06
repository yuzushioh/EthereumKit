//
//  Wallet.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh.
//

import Foundation

public final class Wallet {
    
    private let network: Network
    private let masterPrivateKey: PrivateKey
    
    public init(seed: Data, network: Network) {
        self.network = network
        self.masterPrivateKey = PrivateKey(seed: seed, network: network)
    }
    
    // Ethereum only uses external.
    private enum Change: UInt32 {
        case external
    }
    
    public func generatePrivateKey(at index: UInt32) -> PrivateKey {
        return privateKey(change: .external).derived(at: index)
    }
    
    public func generateAddress(at index: UInt32) -> String {
        return generatePrivateKey(at: index).generateAddress()
    }
    
    // m/44'/coin_type'/0'/external
    private func privateKey(change: Change) -> PrivateKey {
        return masterPrivateKey
            .derived(at: 44, hardens: true)
            .derived(at: network.coinType, hardens: true)
            .derived(at: 0, hardens: true)
            .derived(at: change.rawValue)
    }
}
