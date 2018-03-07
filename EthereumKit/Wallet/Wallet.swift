//
//  Wallet.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh.
//

public final class Wallet {
    
    private let network: Network
    private let masterPrivateKey: PrivateKey
    
    public init(seed: Data, network: Network) {
        self.network = network
        self.masterPrivateKey = PrivateKey(seed: seed, network: network)
    }
    
    // MARK: - Public Methods
    
    public func generatePrivateKey() -> PrivateKey {
        return generatePrivateKey(at: 0)
    }
    
    public func generatePrivateKey(at index: UInt32) -> PrivateKey {
        return privateKey(change: .external).derived(at: index)
    }
    
    public func generateAddress() -> String {
        return generateAddress(at: 0)
    }
    
    public func generateAddress(at index: UInt32) -> String {
        return generatePrivateKey(at: index).generateAddress()
    }
    
    public func signTransaction(_ rawTransaction: RawTransaction) -> String {
        let signer = EIP155Signer(chainID: network.chainID)
        let privateKey = generatePrivateKey()
        let rawData = signer.sign(rawTransaction, with: privateKey.raw)
        return rawData.toHexString().appending0xPrefix
    }
    
    // MARK: - Private Methods
    
    // Ethereum only uses external.
    private enum Change: UInt32 {
        case external
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
