import SwiftUI

public struct SkeletonCard: View {
    @State private var phase: CGFloat = 0

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.WL.warmSubtle
                .frame(height: 158)

            VStack(alignment: .leading, spacing: WLSpacing.sm) {
                skeletonLine(width: .infinity, height: 16)
                skeletonLine(width: 140, height: 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    skeletonLine(width: 70, height: 30)
                    Spacer()
                    skeletonLine(width: 100, height: 40)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
        }
        .background(Color.WL.surface)
        .clipShape(RoundedRectangle(cornerRadius: WLRadius.card))
        .overlay(
            RoundedRectangle(cornerRadius: WLRadius.card)
                .stroke(Color.WL.cardBorder, lineWidth: 1)
        )
        .overlay(shimmerOverlay)
        .clipShape(RoundedRectangle(cornerRadius: WLRadius.card))
        .onAppear {
            withAnimation(WLAnimation.shimmer) {
                phase = 1
            }
        }
    }

    private func skeletonLine(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.WL.warmSubtle)
            .frame(width: width == .infinity ? nil : width, height: height)
            .frame(maxWidth: width == .infinity ? .infinity : nil)
    }

    private var shimmerOverlay: some View {
        GeometryReader { geo in
            let w = geo.size.width
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: Color.WL.shimmerHighlight.opacity(0.8), location: 0.5),
                    .init(color: .clear, location: 1),
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: w * 2.5)
            .offset(x: -w + phase * w * 3.5)
        }
        .allowsHitTesting(false)
    }
}
