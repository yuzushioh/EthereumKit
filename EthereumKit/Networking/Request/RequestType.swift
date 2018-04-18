public protocol RequestType {
    associatedtype Response
    
    var baseURL: URL { get }
    
    var method: Method { get }
    
    var path: String { get }
    
    var parameters: Any? { get }
    
    var headerFields: [String: String] { get }
    
    func response(from object: Any) throws -> Response
}

extension RequestType {
    public var headerFields: [String: String] {
        return [:]
    }
    
    public var parameters: Any? {
        return nil
    }
    
    public var queryParameters: [String: Any]? {
        guard let parameters = parameters as? [String: Any], method.prefersQueryParameters else {
            return nil
        }
        
        return parameters
    }
}

extension RequestType where Response: Decodable {
    public func response(from object: Any) throws -> Response {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
