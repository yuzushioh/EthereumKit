//
//  Geth.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Result

public final class Geth {
    
    private let etherClient: EtherClient
    
    public init(network: Network) {
        etherClient = EtherClient(network: network)
    }
    
    public func getBalance(of address: String, blockParameter: BlockParameter = .latest, handler: @escaping (Result<Balance, RPCError>) -> Void) {
        let rpc = RPC.GetBalance(address: address, blockParameter: blockParameter)
        etherClient.send(rpc, handler: handler)
    }
}
