protocol BatchElementType {
    associatedtype Request: JSONRPCRequest
    
    var request: Request { get }
    var version: String { get }
    var id: Int { get }
    var body: Any { get }
    
    func response(from: Any) throws -> Request.Response
    func result(from: Any) -> Result<Request.Response>
}

internal extension BatchElementType {
    internal func response(from object: Any) throws -> Request.Response {
        switch result(from: object) {
        case .success(let response):
            return response
            
        case .failure(let error):
            throw error
        }
    }
    
    internal func result(from object: Any) -> Result<Request.Response> {
        guard let dictionary = object as? [String: Any] else {
            return .failure(EthereumKitError.responseError(.jsonrpcError(.unexpectedTypeObject(object))))
        }
        
        let receivedVersion = dictionary["jsonrpc"] as? String
        guard version == receivedVersion else {
            return .failure(EthereumKitError.responseError(.jsonrpcError(.unsupportedVersion(receivedVersion))))
        }
        
        let receivedId = dictionary["id"] as? Int
        guard id == receivedId else {
            return .failure(EthereumKitError.responseError(.jsonrpcError(.responseNotFound(requestId: id, object: dictionary))))
        }
        
        let resultObject = dictionary["result"]
        let errorObject = dictionary["error"]
        
        switch (resultObject, errorObject) {
        case (nil, let errorObject?):
            return .failure(EthereumKitError.responseError(.jsonrpcError(JSONRPCError(errorObject: errorObject))))
            
        case (let resultObject?, nil):
            do {
                return .success(try request.response(from: resultObject))
            } catch {
                return .failure(EthereumKitError.responseError(.jsonrpcError(.resultObjectParseError(error))))
            }
            
        default:
            return .failure(EthereumKitError.responseError(.jsonrpcError(.missingBothResultAndError(dictionary))))
        }
    }
}

internal extension BatchElementType where Request.Response == Void {
    internal func response(_ object: Any) throws -> Request.Response {
        return ()
    }
    
    internal func result(_ object: Any) -> Result<Request.Response> {
        return .success(())
    }
}

public struct BatchElement<Request: JSONRPCRequest>: BatchElementType {
    public let request: Request
    public let version: String
    public let id: Int
    public let body: Any
    
    public init(request: Request, version: String, id: Int) {
        var body: [String: Any] = [
            "jsonrpc": version,
            "method": request.method,
            "id": id
        ]
        
        if let parameters = request.parameters {
            body["params"] = parameters
        }
        
        self.request = request
        self.version = version
        self.id = id
        self.body = body
    }
}
