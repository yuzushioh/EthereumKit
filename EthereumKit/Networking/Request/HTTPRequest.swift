import APIKit

public struct HTTPRequest<Request: APIKit.Request>: APIKit.Request {
    
    public typealias Response = Request.Response
    
    private let baseRequest: Request
    
    public init(_ baseRequest: Request) {
        self.baseRequest = baseRequest
    }
    
    public var baseURL: URL {
        return baseRequest.baseURL
    }
    
    public var path: String {
        return baseRequest.path
    }
    
    public var method: HTTPMethod {
        return baseRequest.method
    }
    
    public var parameters: Any? {
        return baseRequest.parameters
    }
    
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Request.Response {
        return try baseRequest.response(from: object, urlResponse: urlResponse)
    }
}
