import SwiftUI
import UIKit

public struct WarningBanner: View {
    public let message: String

    public init(_ message: String) {
        self.message = message
    }

    public var body: some View {
        HStack(alignment: .top, spacing: WLSpacing.sm) {
            ZStack {
                Circle()
                    .fill(Color.WL.accent)
                    .frame(width: 20, height: 20)
                Text("!")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
            Text(message)
                .textStyle(.footnote)
                .foregroundStyle(Color.WL.warningText)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 11)
        .background(Color.WL.accentTint)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(UIColor(hex: 0xF0D49A)), lineWidth: 1)
        )
    }
}
