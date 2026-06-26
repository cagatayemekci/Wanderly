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
            let time = WLFormatters.time.string(from: stop.arrival)
            lines.append("\(i + 1). \(stop.place.name) – \(time)")
        }
        lines.append("")
        let duration = WLFormatters.duration(summary.totalDurationMin)
        lines.append("Total: \(summary.totalStops) stops · \(duration) · \(summary.totalCostLevel.display)")
        lines.append("")
        lines.append("Made with Wanderly")
        return lines.joined(separator: "\n")
    }

    init(planStore: PlanStore) {
        self.planStore = planStore
    }

}
