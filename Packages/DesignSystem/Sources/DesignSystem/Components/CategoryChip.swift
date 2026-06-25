import SwiftUI

public struct CategoryChip: View {
    public let label: String
    public let isSelected: Bool
    public let action: () -> Void

    public init(label: String, isSelected: Bool, action: @escaping () -> Void) {
        self.label = label
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(label)
                .textStyle(.micro)
                .foregroundStyle(isSelected ? Color.WL.background : Color(red: 0.353, green: 0.290, blue: 0.259))
                .padding(.horizontal, WLSpacing.lg)
                .padding(.vertical, 9)
                .background(isSelected ? Color.WL.ink900 : Color.WL.surface)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.WL.border, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
