public protocol HTTPClientType {
    @discardableResult
    func send<Request: RequestType>(
        _ request: Request,
        completionHandler: @escaping (Result<Request.Response>) -> Void) -> Cancellable?
    
    @discardableResult
    func send<Request: JSONRPCRequest>(
        _ request: Request,
        completionHandler: @escaping (Result<Request.Response>) -> Void) -> Cancellable?
}
