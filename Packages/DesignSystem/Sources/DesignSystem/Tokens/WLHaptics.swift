import UIKit

public enum WLHaptics {
    public static func light()   { impact(.light) }
    public static func medium()  { impact(.medium) }
    public static func soft()    { impact(.soft) }
    public static func success() { notify(.success) }
    public static func warning() { notify(.warning) }

    private static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    private static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
