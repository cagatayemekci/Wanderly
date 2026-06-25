public enum Category: String, CaseIterable, Hashable, Sendable {
    case all
    case landmark
    case restaurant
    case cafe
    case activity
    case shopping

    public var displayLabel: String {
        switch self {
        case .all:        return "All"
        case .landmark:   return "Landmarks"
        case .restaurant: return "Eat"
        case .cafe:       return "Cafes"
        case .activity:   return "Activities"
        case .shopping:   return "Shopping"
        }
    }

    public var sfSymbol: String {
        switch self {
        case .all:        return "square.grid.2x2"
        case .landmark:   return "building.columns"
        case .restaurant: return "fork.knife"
        case .cafe:       return "cup.and.saucer"
        case .activity:   return "figure.walk"
        case .shopping:   return "bag"
        }
    }
}
