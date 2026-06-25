import SwiftUI

public struct TravelGapConnector: View {
    public let label: String

    public init(label: String) {
        self.label = label
    }

    public var body: some View {
        HStack(spacing: WLSpacing.sm) {
            dashedLine
            Text(label)
                .textStyle(.caption)
                .foregroundStyle(Color.WL.ink400)
                .fixedSize()
            dashedLine
        }
        .padding(.horizontal, WLSpacing.lg)
    }

    private var dashedLine: some View {
        Rectangle()
            .fill(Color.WL.warmMid)
            .frame(height: 1)
            .overlay(
                GeometryReader { geo in
                    Path { path in
                        var x: CGFloat = 0
                        while x < geo.size.width {
                            path.move(to: CGPoint(x: x, y: 0.5))
                            path.addLine(to: CGPoint(x: min(x + 4, geo.size.width), y: 0.5))
                            x += 9
                        }
                    }
                    .stroke(Color.WL.warmMid, style: StrokeStyle(lineWidth: 1, dash: [4, 5]))
                }
            )
    }
}
