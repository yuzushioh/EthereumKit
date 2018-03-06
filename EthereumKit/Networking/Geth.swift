//
//  Geth.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Result

public final class Geth {
    
    private let etherClient: JSONRPCClient
    private let etherscanClient: EtherscanClient
    
    public init(network: Network) {
        etherClient = JSONRPCClient(network: network)
        etherscanClient = EtherscanClient(network: network)
    }
    
    // MARK: - JSONRPC APIs
    
    public func getBalance(of address: Address, blockParameter: BlockParameter = .latest, handler: @escaping (Result<Balance, GethError>) -> Void) {
        etherClient.send(JSONRPC.GetBalance(address: address, blockParameter: blockParameter), handler: handler)
    }
    
    public func getTransactionCount(of address: Address, blockParameter: BlockParameter = .latest, handler: @escaping (Result<UInt64, GethError>) -> Void) {
        etherClient.send(JSONRPC.GetTransactionCount(address: address, blockParameter: blockParameter), handler: handler)
    }
    
    public func sendRawTransaction(rawTransaction: String, handler: @escaping (Result<SentTransaction, GethError>) -> Void) {
        etherClient.send(JSONRPC.SendRawTransaction(rawTransaction: rawTransaction), handler: handler)
    }
    
    public func getAccount(address: Address, blockParameter: BlockParameter = .latest, handler: @escaping (Result<Account, GethError>) -> Void) {
        getBalance(of: address) { result in
            switch result {
            case .success(let balance):
                handler(.success(Account(address: address, balance: balance)))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    // MARK: - Etherscan APIs
    
    public func getTransactions(address: Address, handler: @escaping (Result<Transactions, GethError>) -> Void) {
        etherscanClient.send(Etherscan.GetTransactions(address: address), handler: handler)
    }
}
