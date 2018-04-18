public protocol Cancellable: class {
    func cancel()
}

extension URLSessionTask: Cancellable {}
