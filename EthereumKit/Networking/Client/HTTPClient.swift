public class HTTPClient: HTTPClientType {
    
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
            
        case .failure(let ethereumKitError):
            completionHandler(.failure(ethereumKitError))
            return nil
        }
    }
    
    private func buildRequest<Request: RequestType>(from request: Request) -> Result<URLRequest> {
        let absolute = URL(string: request.path, relativeTo: request.baseURL)?.absoluteString
        guard let url = absolute.flatMap(URL.init(string:)) else {
            return .failure(EthereumKitError.requestError(.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue.uppercased()
        
        return .success(urlRequest)
    }
    
    private func buildResponse<Request: RequestType>(for request: Request, from data: Data?, response: URLResponse?, error: Error?) -> Result<Request.Response> {
        if let error = error {
            return .failure(EthereumKitError.responseError(.connectionError(error)))
        }
        
        return .failure(EthereumKitError.cryptoError(.failedToSign))
    }
}
