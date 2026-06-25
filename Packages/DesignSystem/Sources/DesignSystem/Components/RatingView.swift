import SwiftUI

public struct RatingView: View {
    public let rating: Double
    public let reviewCount: Int?

    public init(rating: Double, reviewCount: Int? = nil) {
        self.rating = rating
        self.reviewCount = reviewCount
    }

    public var body: some View {
        HStack(spacing: 3) {
            ForEach(1...5, id: \.self) { position in
                Image(systemName: starImage(for: position))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(isActive(position) ? Color.WL.accent : Color.WL.warmMid)
            }
            Text(String(format: "%.1f", rating))
                .textStyle(.ratingNumber)
                .foregroundStyle(Color.WL.ink900)
            if let count = reviewCount {
                Text("(\(count))")
                    .textStyle(.caption)
                    .foregroundStyle(Color.WL.ink400)
            }
        }
    }

    private func isActive(_ position: Int) -> Bool {
        position <= Int((rating + 0.25).rounded(.down))
    }

    private func starImage(for position: Int) -> String {
        let full = Int(rating)
        let hasHalf = (rating - Double(full)) >= 0.5
        if position <= full { return "star.fill" }
        if position == full + 1 && hasHalf { return "star.leadinghalf.filled" }
        return "star"
    }
}
