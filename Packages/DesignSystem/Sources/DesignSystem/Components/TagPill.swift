import SwiftUI

public struct TagPill: View {
    public let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .textStyle(.caption)
            .foregroundStyle(Color.WL.ink600)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.WL.surface)
            .clipShape(RoundedRectangle(cornerRadius: WLRadius.tag))
            .overlay(
                RoundedRectangle(cornerRadius: WLRadius.tag)
                    .stroke(Color.WL.border, lineWidth: 1)
            )
    }
}
