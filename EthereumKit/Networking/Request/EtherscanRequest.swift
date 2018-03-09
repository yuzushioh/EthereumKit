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
    private let network: Network
    
    public init(_ baseRequest: Request, network: Network) {
        self.baseRequest = baseRequest
        self.network = network
    }
    
    public var baseURL: URL {
        return Endpoint(network: network).etherscanURL
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
        parameters["apikey"] = "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7"
        return parameters
    }
    
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Request.Response {
        return try baseRequest.response(from: object, urlResponse: urlResponse)
    }
}
