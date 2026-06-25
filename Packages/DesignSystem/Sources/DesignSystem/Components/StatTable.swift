import SwiftUI

public struct StatRow: Hashable, Sendable {
    public let label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}

public struct StatTable: View {
    public let rows: [StatRow]

    public init(rows: [StatRow]) {
        self.rows = rows
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                HStack {
                    Text(row.label)
                        .textStyle(.footnote)
                        .foregroundStyle(Color.WL.ink600)
                    Spacer()
                    Text(row.value)
                        .textStyle(.headline)
                        .foregroundStyle(Color.WL.ink900)
                }
                .padding(.horizontal, WLSpacing.md)
                .padding(.vertical, 14)

                if index < rows.count - 1 {
                    Rectangle()
                        .fill(Color.WL.cardBorder)
                        .frame(height: 1)
                }
            }
        }
        .background(Color.WL.surface)
        .clipShape(RoundedRectangle(cornerRadius: WLRadius.timeline))
    }
}
