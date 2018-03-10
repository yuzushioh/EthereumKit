import APIKit

public protocol EtherscanRequestType {
    associatedtype Response
    var method: HTTPMethod { get }
    var parameters: Any? { get }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response
}

extension EtherscanRequestType where Response: Decodable {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

public struct EtherscanRequest<Request: EtherscanRequestType>: APIKit.Request {
    
    public typealias Response = Request.Response
    
    private let baseRequest: Request
    private let endpoint: URL
    private let apiKey: String
    
    public init(_ baseRequest: Request, endpoint: URL, apiKey: String) {
        self.baseRequest = baseRequest
        self.endpoint = endpoint
        self.apiKey = apiKey
    }
    
    public var baseURL: URL {
        return endpoint
    }
    
    public var method: HTTPMethod {
        return baseRequest.method
    }
    
    public var path: String {
        return "/api"
    }
    
    public var parameters: Any? {
        var parameters: [String: Any] = [:]
        if let originalParameters = baseRequest.parameters as? [String: Any] {
            parameters = originalParameters
        }
        parameters["apikey"] = apiKey
        return parameters
    }
    
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Request.Response {
        return try baseRequest.response(from: object, urlResponse: urlResponse)
    }
}
