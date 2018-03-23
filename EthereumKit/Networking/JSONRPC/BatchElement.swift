public struct BatchElement<Request: JSONRPCRequest> {
    public let request: Request
    public let version: String
    public let id: Int
    public let body: Any
    
    public init(request: Request, version: String, id: Int) {
        let body: [String: Any] = [
            "jsonrpc": version,
            "method": request.method,
            "id": id
        ]
        
        self.request = request
        self.version = version
        self.id = id
        self.body = body
    }
}
