import SwiftUI

public struct SearchInput: View {
    @Binding public var text: String
    public let placeholder: String

    public init(text: Binding<String>, placeholder: String = "Search places…") {
        self._text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        HStack(spacing: WLSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.WL.ink400)
            TextField(
                text: $text,
                prompt: Text(placeholder).foregroundColor(Color.WL.ink400)
            ) {
                EmptyView()
            }
            .foregroundStyle(Color.WL.ink900)
            .textStyle(.body)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.WL.ink400)
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(Color.WL.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.WL.border, lineWidth: 1)
        )
        .accessibilityIdentifier("searchInput")
    }
}
