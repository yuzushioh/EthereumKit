public enum Method: String {
    case get, post
}

public protocol RequestType {
    associatedtype Response
    
    var baseURL: URL { get }
    var method: Method { get }
    var path: String { get }
    var parameters: Any? { get }
    var headerFields: [String: Any]? { get }
    
    func response(from object: Any) throws -> Response
}

extension RequestType {
    public var headerFields: [String: Any]? {
        return nil
    }
    
    public var parameters: Any? {
        return nil
    }
}

extension RequestType where Response: Decodable {
    public func response(from object: Any) throws -> Response {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
