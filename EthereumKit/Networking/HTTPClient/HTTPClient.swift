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
        switch request.build() {
        case .success(let urlRequest):
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                let result = request.buildResponse(from: data, response: response, error: error)
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
}
