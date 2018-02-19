//
//  JSONRPCClient.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/17.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import JSONRPCKit
import Result

public final class JSONRPCClient: APIClient {
    
    private let batchFactory = BatchFactory(version: "2.0", idGenerator: IDGenerator())
    
    public func send<RPC: JSONRPCKit.Request>(_ rpc: RPC, handler: @escaping (Result<RPC.Response, RPCError>) -> Void) {
        let batch = batchFactory.create(rpc)
        let httpRequest = HTTPJSONRPCRequest(batch: batch, network: network)
        send(httpRequest, handler: handler)
    }
}
