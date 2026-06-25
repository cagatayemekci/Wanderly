import SwiftUI

public struct EmptyStateView: View {
    public let systemImage: String
    public let title: String
    public let subtitle: String
    public let ctaTitle: String
    public let ctaAction: () -> Void

    public init(
        systemImage: String = "map",
        title: String,
        subtitle: String,
        ctaTitle: String,
        ctaAction: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.ctaTitle = ctaTitle
        self.ctaAction = ctaAction
    }

    public var body: some View {
        VStack(spacing: WLSpacing.xl) {
            iconView
            VStack(spacing: WLSpacing.sm) {
                Text(title)
                    .textStyle(.heroTitle)
                    .foregroundStyle(Color.WL.ink900)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .textStyle(.body)
                    .foregroundStyle(Color.WL.ink600)
                    .multilineTextAlignment(.center)
            }
            PrimaryButton(ctaTitle, action: ctaAction)
                .padding(.horizontal, WLSpacing.xl)
        }
        .padding(WLSpacing.xl)
    }

    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.WL.primaryTint)
                .frame(width: 96, height: 96)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.WL.primary.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
                        .padding(6)
                )
            Image(systemName: systemImage)
                .font(.system(size: 38, weight: .medium))
                .foregroundStyle(Color.WL.primary)
        }
    }
}
