import SwiftUI

public extension View {
    func wlPulse() -> some View {
        modifier(WLPulseModifier())
    }
}

private struct WLPulseModifier: ViewModifier {
    @State private var active = false
    func body(content: Content) -> some View {
        content
            .opacity(active ? 1.0 : 0.55)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    active = true
                }
            }
    }
}

public enum WLAnimation {
    public static let cardEntrance = Animation.timingCurve(0.2, 0.7, 0.3, 1, duration: 0.5)
    public static let cardEntranceStagger: Double = 0.06
    public static let summaryStagger: Double = 0.07
    public static let summaryBaseDelay: Double = 0.05
    public static let shimmer = Animation.linear(duration: 1.4).repeatForever(autoreverses: false)
    public static let cardPress = Animation.spring(response: 0.3, dampingFraction: 0.7)
    public static let liftedCard = Animation.spring(response: 0.25, dampingFraction: 0.6)

    // Swaps to a plain opacity fade when Reduce Motion is enabled
    public static func cardEntrance(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeIn(duration: 0.25) : cardEntrance
    }
}
