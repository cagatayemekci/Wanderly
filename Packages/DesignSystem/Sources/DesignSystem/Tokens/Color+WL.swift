import SwiftUI
import UIKit

// MARK: - UIColor hex convenience (internal to DesignSystem)
extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(
            red:   CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8)  & 0xFF) / 255,
            blue:  CGFloat(hex         & 0xFF) / 255,
            alpha: alpha
        )
    }
}

extension Color {
    static func wlAdaptive(light: UInt32, dark: UInt32) -> Color {
        Color(UIColor { tc in
            UIColor(hex: tc.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

// MARK: - Design tokens
extension Color {
    public enum WL {
        public static let background     = Color.wlAdaptive(light: 0xFBF5EF, dark: 0x17110F)
        public static let surface        = Color.wlAdaptive(light: 0xFFFFFF, dark: 0x221A17)
        public static let surface2       = Color.wlAdaptive(light: 0xF4EAE1, dark: 0x2C221E)
        public static let ink900         = Color.wlAdaptive(light: 0x2B1D17, dark: 0xF3E9E2)
        public static let ink600         = Color.wlAdaptive(light: 0x6B5A50, dark: 0xB6A79E)
        public static let ink400         = Color.wlAdaptive(light: 0xA8968C, dark: 0x87766C)
        public static let primary        = Color.wlAdaptive(light: 0xC25C52, dark: 0xE07A6E)
        public static let primaryTint    = Color.wlAdaptive(light: 0xF7E4DF, dark: 0x3A211D)
        public static let accent         = Color.wlAdaptive(light: 0xE0992E, dark: 0xEBB05A)
        public static let accentTint     = Color.wlAdaptive(light: 0xFBEBD0, dark: 0x3A2E1B)
        public static let error          = Color(UIColor(hex: 0xC0443B))
        public static let success        = Color(UIColor(hex: 0x3E8E5C))
        public static let border         = Color.wlAdaptive(light: 0xECE0D6, dark: 0x2C2320)
        public static let cardBorder     = Color.wlAdaptive(light: 0xF1E7DD, dark: 0x332925)
        public static let cardBorderAdded = Color(UIColor(hex: 0xE3A79F))
        public static let warmMid        = Color.wlAdaptive(light: 0xD8C7BB, dark: 0x332925)
        public static let warmSubtle     = Color.wlAdaptive(light: 0xEFE4DA, dark: 0x2C2320)
        public static let removeText     = Color.wlAdaptive(light: 0xA94A41, dark: 0xE07A6E)
        public static let warningText    = Color.wlAdaptive(light: 0x8A5A12, dark: 0xA07832)
        public static let mapBg          = Color.wlAdaptive(light: 0xEAE5DA, dark: 0x241C18)
        public static let shimmerHighlight = Color.wlAdaptive(light: 0xF7EFE7, dark: 0x3A2E28)
    }
}
