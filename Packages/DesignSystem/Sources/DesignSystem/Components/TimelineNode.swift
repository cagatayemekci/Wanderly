import SwiftUI

public struct TimelineNode: View {
    public let index: Int

    public init(index: Int) {
        self.index = index
    }

    public var body: some View {
        Text("\(index)")
            .textStyle(.badgeCount)
            .foregroundStyle(.white)
            .frame(width: 28, height: 28)
            .background(Color.WL.primary)
            .clipShape(Circle())
    }
}
