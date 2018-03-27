public protocol URLSchemeHandlerType {
    static func createAction(from url: URL) -> URLSchemeAction?
}

public final class URLSchemeHandler: URLSchemeHandlerType {
    
    public static func createAction(from url: URL) -> URLSchemeAction? {
        return URLSchemeAction(url: url)
    }
}
