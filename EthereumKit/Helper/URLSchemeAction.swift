public enum URLSchemeAction {
    case send(to: String, value: String?, data: String?, gasLimit: Gas.GasLimit?, gasPrice: Gas.GasPrice?, callBack: URL?)
    case sign(data: String, callBack: URL)
    
    internal init?(url: URL) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let host = urlComponents.host,
            let scheme = urlComponents.scheme, scheme == "ethereum",
            let queryItems = urlComponents.queryItems else {
                return nil
        }
        
        let value = queryItems.first(where: { $0.name == "value" })?.value
        let data = queryItems.first(where: { $0.name == "data" })?.value
        
        let gasLimit = queryItems.first(where: { $0.name == "gasLimit" })?.value
            .flatMap(Int.init)
            .flatMap({ Gas.GasLimit.custom($0) })
        
        let gasPrice = queryItems.first(where: { $0.name == "gasPrice" })?.value
            .flatMap(Int.init)
            .flatMap({ Gas.GasPrice.custom(GWei: $0) })
        
        let callBack = queryItems.first(where: { $0.name == "callback" })?.value
            .flatMap(URL.init)
        
        self = .send(to: host, value: value, data: data, gasLimit: gasLimit, gasPrice: gasPrice, callBack: callBack)
    }
}
