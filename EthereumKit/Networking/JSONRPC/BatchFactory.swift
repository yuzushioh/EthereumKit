public final class BatchFactory {
    public let version: String
    
    private var idGenerator = IDGenerator()
    private let semaphore = DispatchSemaphore(value: 1)
    
    public init(version: String = "2.0") {
        self.version = version
    }
    
    public func create<Request: JSONRPCRequest>(_ request: Request) -> Batch1<Request> {
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        let batchElement = BatchElement(request: request, version: version, id: idGenerator.next())
        semaphore.signal()
        return Batch1(batchElement: batchElement)
    }
    
    public func create<Request1: JSONRPCRequest, Request2: JSONRPCRequest>(_ request1: Request1, _ request2: Request2) -> Batch2<Request1, Request2> {
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        let batchElement1 = BatchElement(request: request1, version: version, id: idGenerator.next())
        let batchElement2 = BatchElement(request: request2, version: version, id: idGenerator.next())
        semaphore.signal()
        return Batch2(batchElement1: batchElement1, batchElement2: batchElement2)
    }
}
