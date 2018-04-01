public enum WordList {
    case english
    case japanese
    
    var words: [String] {
        switch self {
        case .english:
            return englishWords
        case .japanese:
            return japaneseWords
        }
    }
}
