import SwiftUI
import Domain
import UIKit

public extension Domain.Category {
    var categoryGradient: LinearGradient {
        LinearGradient(
            colors: gradientColors,
            startPoint: UnitPoint(x: 0, y: 1),
            endPoint: UnitPoint(x: 1, y: 0)
        )
    }

    private var gradientColors: [Color] {
        switch self {
        case .landmark:
            return [Color(UIColor(hex: 0xC9612E)), Color(UIColor(hex: 0xE2A24A))]
        case .restaurant:
            return [Color(UIColor(hex: 0x1B3A6B)), Color(UIColor(hex: 0x2E5E9E))]
        case .cafe:
            return [Color(UIColor(hex: 0x6F7E3F)), Color(UIColor(hex: 0xA6B468))]
        case .activity:
            return [Color(UIColor(hex: 0x9A8246)), Color(UIColor(hex: 0xC9B06A))]
        case .shopping:
            return [Color(UIColor(hex: 0xA23E5E)), Color(UIColor(hex: 0xD06A86))]
        case .all:
            return [Color(UIColor(hex: 0xC9612E)), Color(UIColor(hex: 0xE2A24A))]
        }
    }
}
