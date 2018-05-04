public protocol RequestType {
    associatedtype Response
    
    var baseURL: URL { get }
    
    var method: Method { get }
    
    var path: String { get }
    
    var parameters: Any? { get }
    
    var headerFields: [String: String] { get }
    
    func build() -> Result<URLRequest>
    
    func buildResponse(from data: Data?, response: URLResponse?, error: Error?) -> Result<Response>
    
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
    
    public var bodyParameters: JSONBodySerialization? {
        guard let parameters = parameters, !method.prefersQueryParameters else {
            return nil
        }
        
        return JSONBodySerialization(parameters)
    }
}

extension RequestType {
    public func build() -> Result<URLRequest> {
        let url = path.isEmpty ? baseURL : baseURL.appendingPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return .failure(EthereumKitError.requestError(.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        
        if let queryParameters = queryParameters {
            components.percentEncodedQuery = URLEncodedSerialization.string(from: queryParameters)
        }
        
        if let bodyParameters = bodyParameters {
            urlRequest.setValue(bodyParameters.contentType, forHTTPHeaderField: "Content-Type")
            
            switch bodyParameters.build() {
            case .success(let data):
                urlRequest.httpBody = data
                
            case.failure(let error):
                return .failure(error)
            }
        }
        
        urlRequest.cachePolicy = .useProtocolCachePolicy
        urlRequest.timeoutInterval = 6.0
        urlRequest.httpMethod = method.rawValue.uppercased()
        
        headerFields.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return .success(urlRequest)
    }
    
    public func buildResponse(from data: Data?, response: URLResponse?, error: Error?) -> Result<Response> {
        if let error = error {
            return .failure(EthereumKitError.responseError(.connectionError(error)))
        }
        
        guard let data = data, let urlResponse = response as? HTTPURLResponse else {
            return .failure(EthereumKitError.responseError(.noContentProvided))
        }
        
        guard (200..<300).contains(urlResponse.statusCode) else {
            return .failure(EthereumKitError.responseError(.unacceptableStatusCode(urlResponse.statusCode)))
        }
        
        let response: Response
        do {
            response = try self.response(from: try parse(from: data))
        } catch let error {
            return .failure(EthereumKitError.responseError(.unexpected(error)))
        }
        
        return .success(response)
    }
    
    private func parse(from data: Data) throws -> Any {
        guard data.count > 0 else {
            return [:]
        }
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
}

extension RequestType where Response: Decodable {
    public func response(from object: Any) throws -> Response {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
