import SwiftUI
import Domain

public struct PriceLevelView: View {
    public let level: PriceLevel

    public init(level: PriceLevel) {
        self.level = level
    }

    public var body: some View {
        if level == .free {
            Text("Free")
                .textStyle(.priceLevel)
                .foregroundStyle(Color.WL.success)
        } else {
            HStack(spacing: 1) {
                ForEach(1...4, id: \.self) { i in
                    Text("$")
                        .textStyle(.priceLevel)
                        .foregroundStyle(i <= level.numericValue ? Color.WL.ink600 : Color.WL.warmMid)
                }
            }
        }
    }
}
