/// https://github.com/ethereum/wiki/wiki/JSON-RPC#the-default-block-parameter
/// String "earliest" for the earliest/genesis block
/// String "latest" - for the latest mined block
/// String "pending" - for the pending state/transactions
public enum BlockParameter: String {
    case latest, earliest, pending
}
