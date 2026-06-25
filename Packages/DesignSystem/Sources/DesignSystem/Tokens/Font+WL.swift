import SwiftUI

// SF system font helpers — Nunito maps to rounded design, Plus Jakarta Sans to default
extension Font {
    static func wlRounded(_ weight: Weight, size: CGFloat) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func wlSans(_ weight: Weight, size: CGFloat) -> Font {
        .system(size: size, weight: weight)
    }
}

// MARK: - Text style enum
public enum WLTextStyle {
    case display        // 32pt, black, rounded  — hero numbers
    case heroTitle      // 27pt, black, rounded  — screen titles
    case pageHeader     // 40pt, black, rounded  — canvas header
    case headline       // 17pt, semibold        — card headers
    case cardTitle      // 16pt, bold            — PlaceCard name
    case detailTitle    // 24pt, black, rounded  — place name in sheet
    case body           // 16pt, regular         — descriptions
    case bodyMedium     // 15pt, medium          — detail body
    case footnote       // 13pt, semibold        — meta, badges
    case caption        // 12pt, medium          — sub-labels
    case micro          // 11pt, bold            — tags, overlines
    case timelineTime   // 12pt, bold, rounded   — stop timestamps
    case ratingNumber   // 13pt, black, rounded  — star rating number
    case badgeCount     // 13pt, black, rounded  — FAB badge, node numbers
    case priceLevel     // 12pt, bold, rounded   — price indicator

    public var font: Font {
        switch self {
        case .display:      return .wlRounded(.black, size: 32)
        case .heroTitle:    return .wlRounded(.black, size: 27)
        case .pageHeader:   return .wlRounded(.black, size: 40)
        case .headline:     return .wlSans(.semibold, size: 17)
        case .cardTitle:    return .wlSans(.bold, size: 16)
        case .detailTitle:  return .wlRounded(.black, size: 24)
        case .body:         return .wlSans(.regular, size: 16)
        case .bodyMedium:   return .wlSans(.medium, size: 15)
        case .footnote:     return .wlSans(.semibold, size: 13)
        case .caption:      return .wlSans(.medium, size: 12)
        case .micro:        return .wlSans(.bold, size: 11)
        case .timelineTime: return .wlRounded(.bold, size: 12)
        case .ratingNumber: return .wlRounded(.black, size: 13)
        case .badgeCount:   return .wlRounded(.black, size: 13)
        case .priceLevel:   return .wlRounded(.bold, size: 12)
        }
    }
}

public extension View {
    func textStyle(_ style: WLTextStyle) -> some View {
        font(style.font)
    }
}
