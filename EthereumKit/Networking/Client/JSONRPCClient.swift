import Result

public final class JSONRPCClient: APIClient {
    
    private let batchFactory = BatchFactory(version: "2.0")
    
    public let configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func send<RPC: JSONRPCRequest>(_ rpc: RPC, handler: @escaping (Result<RPC.Response, GethError>) -> Void) {
        let batch = batchFactory.create(rpc)
        let httpRequest = HTTPJSONRPCRequest(batch: batch, endpoint: URL(string: configuration.nodeEndpoint)!)
        send(httpRequest, handler: handler)
    }
}
