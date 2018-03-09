import JSONRPCKit
import APIKit

public struct HTTPJSONRPCRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    
    public typealias Response = Batch.Responses
    
    private let network: Network
    private let batch: Batch
    
    public init(batch: Batch, network: Network) {
        self.network = network
        self.batch = batch
    }
    
    public var baseURL: URL {
        return Endpoint(network: network).infuraURL
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
