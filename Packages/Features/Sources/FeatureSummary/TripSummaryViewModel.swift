import Foundation
import Observation
import Domain

@Observable
@MainActor
final class TripSummaryViewModel {
    private let planStore: PlanStore

    var places: [Place] { planStore.itinerary }
    var summary: TripSummary { TripSummaryCalculator.calculate(places, startTime: .nineAM) }

    var categoryBreakdown: [(category: Domain.Category, count: Int)] {
        summary.perCategoryCount
            .map { (category: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }

    var shareText: String {
        var lines: [String] = ["My Jaipur Itinerary", ""]
        for (i, stop) in summary.stops.enumerated() {
            let time = Self.timeFormatter.string(from: stop.arrival)
            lines.append("\(i + 1). \(stop.place.name) – \(time)")
        }
        lines.append("")
        let duration = formatDuration(summary.totalDurationMin)
        lines.append("Total: \(summary.totalStops) stops · \(duration) · \(summary.totalCostLevel.display)")
        lines.append("")
        lines.append("Made with Wanderly")
        return lines.joined(separator: "\n")
    }

    init(planStore: PlanStore) {
        self.planStore = planStore
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .none; f.timeStyle = .short; return f
    }()

    private func formatDuration(_ minutes: Int) -> String {
        let h = minutes / 60, m = minutes % 60
        if h == 0 { return "\(m)min" }
        if m == 0 { return "\(h)h" }
        return "\(h)h \(m)m"
    }
}
