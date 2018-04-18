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
