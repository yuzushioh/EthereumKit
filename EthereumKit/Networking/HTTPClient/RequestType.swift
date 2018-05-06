/// Defines the interface for the request
public protocol RequestType {
    
    /// Response of the request
    associatedtype Response
    
    /// base url of the request
    var baseURL: URL { get }
    
    /// method to use
    var method: Method { get }
    
    /// path to the endpoint
    var path: String { get }
    
    /// parameters to send with
    var parameters: Any? { get }
    
    /// response(from object:) method decodes returned object to Response
    ///
    /// - Parameter object: JSON object returned from url request
    /// - Returns: Response object
    /// - Throws: throws decode error if necessary
    func response(from object: Any) throws -> Response
}

extension RequestType {
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
    
    /// build method builds url request
    ///
    /// - Returns: built url request
    public func build() -> Result<URLRequest> {
        let url = path.isEmpty ? baseURL : baseURL.appendingPathComponent(path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return .failure(EthereumKitError.requestError(.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
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
        
        urlRequest.url = components.url
        urlRequest.cachePolicy = .useProtocolCachePolicy
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = method.rawValue.uppercased()
        
        return .success(urlRequest)
    }
    
    /// buildResponse method builds response from passed parameters, returns failure for errors
    ///
    /// - Parameters:
    ///   - data: returned data from http response
    ///   - response: returned response from http response
    ///   - error: returned error from http response
    /// - Returns: decoded response
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
    
    /// parse parses data to JSON object
    ///
    /// - Parameter data: data returned from http response
    /// - Returns: JSON object serialized from data
    /// - Throws: serialization error
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
