public struct HTTPJSONRPCRequest<Batch: JSONRPCBatchType>: RequestType {
    public typealias Response = Batch.Responses
    
    private let endpoint: URL
    private let batch: Batch
    
    public init(batch: Batch, endpoint: URL) {
        self.endpoint = endpoint
        self.batch = batch
    }
    
    public var baseURL: URL {
        return endpoint
    }
    
    public var method: Method {
        return .post
    }
    
    public var path: String {
        return "/"
    }
    
    public var parameters: Any? {
        return batch.requestObject
    }
    
    public func response(from object: Any) throws -> Response {
        return try batch.responses(from: object)
    }
}
