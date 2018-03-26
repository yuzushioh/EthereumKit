public protocol URLSchemeHandlerType {
    func createAction(from url: URL) -> URLSchemeAction?
}

public final class URLSchemeHandler: URLSchemeHandlerType {
    
    public func createAction(from url: URL) -> URLSchemeAction? {
        return URLSchemeAction(url: url)
    }
}
