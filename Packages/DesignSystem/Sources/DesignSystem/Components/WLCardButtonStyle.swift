import SwiftUI

public struct WLCardButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect((!reduceMotion && configuration.isPressed) ? 0.97 : 1.0)
            .animation(WLAnimation.cardPress, value: configuration.isPressed)
    }
}
