public enum PriceLevel: String, CaseIterable, Hashable, Sendable {
    case free  = "Free"
    case one   = "$"
    case two   = "$$"
    case three = "$$$"
    case four  = "$$$$"

    public var numericValue: Int {
        switch self {
        case .free:  return 0
        case .one:   return 1
        case .two:   return 2
        case .three: return 3
        case .four:  return 4
        }
    }

    public var display: String { rawValue }
}
