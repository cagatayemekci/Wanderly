import SwiftUI

public struct PrimaryButton: View {
    public let title: String
    public let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(.cardTitle)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.WL.primary)
                .clipShape(RoundedRectangle(cornerRadius: WLRadius.button))
                .wlCTAShadow()
        }
        .buttonStyle(.plain)
    }
}
