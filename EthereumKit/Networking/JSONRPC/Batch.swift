public protocol JSONRPCBatchType {
    associatedtype Responses
    var requestObject: Any { get }
    func responses(from object: Any) throws -> Responses
}

public struct Batch1<Request: JSONRPCRequest>: JSONRPCBatchType {
    public typealias Responses = Request.Response
    
    public let batchElement: BatchElement<Request>
    
    public var requestObject: Any {
        return batchElement.body
    }
    
    public func responses(from object: Any) throws -> Responses {
        return try batchElement.response(from: object)
    }
}

public struct Batch2<Request1: JSONRPCRequest, Request2: JSONRPCRequest>: JSONRPCBatchType {
    public typealias Responses = (Request1.Response, Request2.Response)
    
    public let batchElement1: BatchElement<Request1>
    public let batchElement2: BatchElement<Request2>
    
    public var requestObject: Any {
        return [
            batchElement1.body,
            batchElement2.body
        ]
    }
    
    public func responses(from object: Any) throws -> Responses {
        guard let batchObjects = object as? [Any] else {
            fatalError()
        }
        
        return (
            try batchElement1.response(from: batchObjects),
            try batchElement2.response(from: batchObjects)
        )
    }
}
