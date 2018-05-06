public enum Result<Object> {
    case success(Object)
    case failure(EthereumKitError)
}
