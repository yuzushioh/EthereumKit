public final class EtherscanClient: HTTPClient {
    
    public let configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func send<Request: EtherscanRequestType>(_ request: Request, handler: @escaping (Result<Request.Response>) -> Void) {
        send(EtherscanRequest(request, endpoint: configuration.etherscanURL, apiKey: configuration.etherscanAPIKey), completionHandler: handler)
    }
}
