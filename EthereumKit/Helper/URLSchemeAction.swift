public enum URLSchemeAction {
    case call(to: String, data: String, gasLimit: Gas.GasLimit?, gasPrice: Gas.GasPrice?, callBack: URL?)
    
    internal init?(url: URL) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let host = urlComponents.host,
            let queryItems = urlComponents.queryItems else {
                return nil
        }
        
        switch host {
        case "jsonrpc":
            guard let to = queryItems.first(where: { $0.name == "to" })?.value,
                let data = queryItems.first(where: { $0.name == "data" })?.value else {
                    return nil
            }
            
            let gasLimit = queryItems.first(where: { $0.name == "gasLimit" })?.value
                .flatMap(Int.init)
                .flatMap({ Gas.GasLimit.custom($0) })
            
            let gasPrice = queryItems.first(where: { $0.name == "gasPrice" })?.value
                .flatMap(Int.init)
                .flatMap({ Gas.GasPrice.custom(GWei: $0) })
            
            let callBack = queryItems.first(where: { $0.name == "callback" })?.value
                .flatMap(URL.init)
            
            self = .call(to: to, data: data, gasLimit: gasLimit, gasPrice: gasPrice, callBack: callBack)
            
        default:
            return nil
        }
    }
}
