//
//  EtherscanClient.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/20.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Result

public final class EtherscanClient: APIClient {
    
    public func send<Request: EtherscanRequestType>(_ request: Request, handler: @escaping (Result<Request.Response, GethError>) -> Void) {
        let httpRequest = HTTPRequest(EtherscanRequest(request, network: network))
        send(httpRequest, handler: handler)
    }
}
