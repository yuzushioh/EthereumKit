import APIKit

public struct HTTPJSONRPCRequest<Batch: JSONRPCBatchType>: APIKit.Request {
    
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
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var path: String {
        return "/"
    }
    
    public var parameters: Any? {
        return batch.requestObject
    }
    
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
    }
}

extension HTTPJSONRPCRequest {
    public func intercept(urlRequest: URLRequest) throws -> URLRequest {
        #if DEBUG
            DispatchQueue.global().async {
                if let data = urlRequest.httpBody, let string = String(data: data, encoding: .utf8) {
                    print("-->", string)
                }
            }
        #endif
        
        return urlRequest
    }
}
