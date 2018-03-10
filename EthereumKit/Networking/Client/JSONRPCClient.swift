import JSONRPCKit
import Result

public final class JSONRPCClient: APIClient {
    
    private struct IDGenerator: JSONRPCKit.IdGenerator {
        private var currentIdentifier = 0
        
        mutating func next() -> Id {
            currentIdentifier += 1
            return .number(currentIdentifier)
        }
    }
    
    private let batchFactory = BatchFactory(version: "2.0", idGenerator: IDGenerator())
    
    public func send<RPC: JSONRPCKit.Request>(_ rpc: RPC, handler: @escaping (Result<RPC.Response, GethError>) -> Void) {
        let batch = batchFactory.create(rpc)
        let httpRequest = HTTPJSONRPCRequest(batch: batch, endpoint: URL(string: configuration.nodeEndpoint)!)
        send(httpRequest, handler: handler)
    }
}
