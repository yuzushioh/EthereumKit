import APIKit
import Result

public class APIClient {
    
    public init() {}
    
    private var session: Session = {
        let configuration = URLSessionConfiguration.default
        let adapter = URLSessionAdapter(configuration: configuration)
        return Session(adapter: adapter)
    }()
    
    public func send<Request: APIKit.Request>(_ request: Request, handler: @escaping (Result<Request.Response, EthereumKitError>) -> Void) {
        let httpRequest = HTTPRequest(request)
        session.send(httpRequest) { result in
            switch result {
            case .success(let response):
                handler(.success(response))
            case .failure(let error):
                handler(.failure(EthereumKitError.apiClientError(APIClientError(error))))
            }
        }
    }
}
