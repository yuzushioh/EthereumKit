public protocol JSONRPCRequest {
    associatedtype Response
    
    var method: String { get }
    var parameters: Any? { get }
    
    func response(from resultObject: Any) throws -> Response
}

public extension JSONRPCRequest {
    public var parameters: Any? {
        return nil
    }
}

public extension JSONRPCRequest where Response == Void {
    public func response(from resultObject: Any) throws -> Response {
        return ()
    }
}
