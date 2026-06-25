import Foundation

public extension Date {
    // Returns today at 9:00 AM in the current calendar/timezone.
    // Tests should pass their own Date instead of relying on this.
    static var nineAM: Date {
        Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    }
}
