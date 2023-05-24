public enum Web3Error: Error {
    case transactionSerializationError
    case connectionError
    case dataError
    case walletError
    case inputError(desc: String)
    case nodeError(desc: String)
    case processingError(desc: String)
    case generalError(err: Error)
    case unknownError

    public var errorDescription: String {
        switch self {
        case .transactionSerializationError:
            return "Transaction Serialization Error"
        case .connectionError:
            return "Connection Error"
        case .dataError:
            return "Data Error"
        case .walletError:
            return "Wallet Error"
        case let .inputError(desc):
            return desc
        case let .nodeError(desc):
            return desc
        case let .processingError(desc):
            return desc
        case let .generalError(err):
            return err.localizedDescription
        case .unknownError:
            return "Unknown Error"
        }
    }
}
