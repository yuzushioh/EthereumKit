public class HTTPClient: HTTPClientType {
    
    private let batchFactory = BatchFactory(version: "2.0")
    
    public let configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    @discardableResult
    public func send<Request: JSONRPCRequest>(_ request: Request, completionHandler: @escaping (Result<Request.Response>) -> Void) -> Cancellable? {
        let httpRequest = HTTPJSONRPCRequest(batch: batchFactory.create(request), endpoint: URL(string: configuration.nodeEndpoint)!)
        return send(httpRequest, completionHandler: completionHandler)
    }
    
    @discardableResult
    public func send<Request: RequestType>(_ request: Request, completionHandler: @escaping (Result<Request.Response>) -> Void) -> Cancellable? {
        switch buildRequest(from: request) {
        case .success(let urlRequest):
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                let result = self.buildResponse(for: request, from: data, response: response, error: error)
                
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            
            task.resume()
            return task
            
        case .failure(let error):
            completionHandler(.failure(error))
            return nil
        }
    }
    
    private func buildRequest<Request: RequestType>(from request: Request) -> Result<URLRequest> {
        let absolute = URL(string: request.path, relativeTo: request.baseURL)?.absoluteString
        
        guard let url = absolute.flatMap(URL.init(string:)) else {
            return .failure(EthereumKitError.requestError(.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .useProtocolCachePolicy
        urlRequest.timeoutInterval = 6.0
        urlRequest.httpMethod = request.method.rawValue.uppercased()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.headerFields.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return .success(urlRequest)
    }
    
    private func buildResponse<Request: RequestType>(for request: Request, from data: Data?, response: URLResponse?, error: Error?) -> Result<Request.Response> {
        if let error = error {
            return .failure(EthereumKitError.responseError(.connectionError(error)))
        }
        
        guard let data = data, let urlResponse = response as? HTTPURLResponse else {
            return .failure(EthereumKitError.responseError(.noContentProvided))
        }
        
        guard (200..<300).contains(urlResponse.statusCode) else {
            return .failure(EthereumKitError.responseError(.unacceptableStatusCode(urlResponse.statusCode)))
        }
        
        let response: Request.Response
        do {
            response = try request.response(from: try parse(from: data))
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
