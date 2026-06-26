import SwiftUI

public struct PlanFAB: View {
    public let count: Int
    public let action: () -> Void

    public init(count: Int, action: @escaping () -> Void) {
        self.count = count
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: WLSpacing.sm) {
                Image(systemName: "map")
                    .font(.system(size: 16, weight: .semibold))
                Text("My Plan")
                    .textStyle(.footnote)
                if count > 0 {
                    badge
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, WLSpacing.xl)
            .frame(height: 54)
            .background(Color.WL.primary)
            .clipShape(Capsule())
            .wlFABShadow()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("My Plan, \(count) \(count == 1 ? "place" : "places")")
        .accessibilityIdentifier("planFAB")
    }

    private var badge: some View {
        Text("\(count)")
            .textStyle(.badgeCount)
            .foregroundStyle(Color.WL.primary)
            .frame(width: 24, height: 24)
            .background(.white)
            .clipShape(Circle())
            .contentTransition(.numericText())
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: count)
    }
}
