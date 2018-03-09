import Result

public final class EtherscanClient: APIClient {
    
    public func send<Request: EtherscanRequestType>(_ request: Request, handler: @escaping (Result<Request.Response, GethError>) -> Void) {
        let httpRequest = HTTPRequest(EtherscanRequest(request, network: network))
        send(httpRequest, handler: handler)
    }
}
