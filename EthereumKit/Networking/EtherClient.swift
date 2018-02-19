//
//  EtherClient.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import JSONRPCKit
import APIKit
import Result

public final class EtherClient {
    
    private let network: Network
    
    public init(network: Network) {
        self.network = network
    }
    
    private let batchFactory = BatchFactory(version: "2.0", idGenerator: IDGenerator())
    private var session: Session = {
        let configuration = URLSessionConfiguration.default
        let adapter = URLSessionAdapter(configuration: configuration)
        return Session(adapter: adapter)
    }()
    
    public func send<RPC: JSONRPCKit.Request>(_ rpc: RPC, handler: @escaping (Result<RPC.Response, RPCError>) -> Void) {
        let batch = batchFactory.create(rpc)
        let httpRequest = HTTPJSONRPCRequest(batch: batch, network: network)
        
        session.send(httpRequest) { result in
            switch result {
            case .success(let response):
                handler(.success(response))
            case .failure(let error):
                handler(.failure(RPCError(error)))
            }
        }
    }
}
