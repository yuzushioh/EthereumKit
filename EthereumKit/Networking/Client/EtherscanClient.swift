import Result

public final class EtherscanClient: APIClient {
    
    public let configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func send<Request: EtherscanRequestType>(_ request: Request, handler: @escaping (Result<Request.Response, GethError>) -> Void) {
        let httpRequest = HTTPRequest(EtherscanRequest(request, endpoint: configuration.etherscanURL, apiKey: configuration.etherscanAPIKey))
        send(httpRequest, handler: handler)
    }
}
