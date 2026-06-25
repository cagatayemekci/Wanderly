import SwiftUI
import UIKit

public extension View {
    func wlE1Shadow() -> some View {
        shadow(color: Color(UIColor(hex: 0x2B1D17, alpha: 0.08)), radius: 1, x: 0, y: 1)
    }

    func wlE2Shadow() -> some View {
        shadow(color: Color(UIColor(hex: 0x2B1D17, alpha: 0.12)), radius: 5, x: 0, y: 4)
    }

    func wlE3Shadow() -> some View {
        shadow(color: Color(UIColor(hex: 0x2B1D17, alpha: 0.28)), radius: 11, x: 0, y: 7)
    }

    func wlCardShadow() -> some View {
        self
            .shadow(color: Color(UIColor(hex: 0x2B1D17, alpha: 0.08)), radius: 1, x: 0, y: 1)
            .shadow(color: Color(UIColor(hex: 0x2B1D17, alpha: 0.32)), radius: 10, x: 0, y: 6)
    }

    func wlFABShadow() -> some View {
        shadow(color: Color(UIColor(hex: 0xC25C52, alpha: 0.60)), radius: 9, x: 0, y: 6)
    }

    func wlCTAShadow() -> some View {
        shadow(color: Color(UIColor(hex: 0xC25C52, alpha: 0.60)), radius: 6, x: 0, y: 4)
    }

    func wlDragShadow() -> some View {
        shadow(color: Color(UIColor(hex: 0x2B1D17, alpha: 0.50)), radius: 16, x: 0, y: 11)
    }
}
