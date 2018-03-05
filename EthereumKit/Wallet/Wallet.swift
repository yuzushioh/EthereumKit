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
    
    private let privateKey: PrivateKey
    
    public init(seed: Data, network: Network) {
        self.network = network
        self.privateKey = PrivateKey(seed: seed, network: network)
    }
    
    public func changeAddress(at index: UInt32) -> String {
        return privateKey(change: .internal)
            .derived(at: 0)
            .generateAddress(at: index)
    }
    
    public func changePrivateKey(at index: UInt32) -> PrivateKey {
        return privateKey(change: .internal)
            .derived(at: index)
    }
    
    public func receiveAddress(at index: UInt32) -> String {
        return privateKey(change: .external)
            .derived(at: 0)
            .generateAddress(at: index)
    }
    
    public func receivePrivateKey(at index: UInt32) -> PrivateKey {
        return privateKey(change: .external)
            .derived(at: index)
    }
    
    private enum Change: UInt32 {
        case external, `internal`
    }
    
    // m/44'/60'/0'/change
    private func privateKey(change: Change) -> PrivateKey {
        let purpose = privateKey.derived(at: 44, hardens: true)
        let coinType = purpose.derived(at: network.coinType, hardens: true)
        let account = coinType.derived(at: 0, hardens: true)
        return account.derived(at: change.rawValue)
    }
}
