import Foundation

public enum TripSummaryCalculator {
    // distance_km in mock data is measured from a fixed city origin, not between stops,
    // so real inter-stop travel time can't be computed. We use a flat 15-min heuristic.
    public static let travelGapMin: Int = 15
    private static let tenHoursInMin: Int = 600

    public static func calculate(_ places: [Place], startTime: Date) -> TripSummary {
        guard !places.isEmpty else {
            return TripSummary(
                totalStops: 0,
                totalDurationMin: 0,
                startTime: startTime,
                endTime: startTime,
                stops: [],
                perCategoryCount: [:],
                totalCostLevel: .free,
                exceedsTenHours: false
            )
        }

        var stops: [ItineraryStop] = []
        var cursor = startTime

        for place in places {
            let arrival = cursor
            let departure = arrival.addingTimeInterval(Double(place.estimatedDurationMin) * 60)
            stops.append(ItineraryStop(place: place, arrival: arrival, departure: departure))
            cursor = departure.addingTimeInterval(Double(travelGapMin) * 60)
        }

        let totalVisitMin = places.reduce(0) { $0 + $1.estimatedDurationMin }
        let totalTravelMin = (places.count - 1) * travelGapMin
        let totalDurationMin = totalVisitMin + totalTravelMin

        let endTime = stops.last?.departure ?? startTime

        let perCategoryCount = Dictionary(grouping: places, by: \.category)
            .mapValues(\.count)

        return TripSummary(
            totalStops: places.count,
            totalDurationMin: totalDurationMin,
            startTime: startTime,
            endTime: endTime,
            stops: stops,
            perCategoryCount: perCategoryCount,
            totalCostLevel: aggregateCost(places),
            exceedsTenHours: totalDurationMin > tenHoursInMin
        )
    }

    private static func aggregateCost(_ places: [Place]) -> PriceLevel {
        let total = places.reduce(0) { $0 + $1.priceLevel.numericValue }
        let avg = Int((Double(total) / Double(places.count)).rounded())
        return PriceLevel.allCases.first { $0.numericValue == avg } ?? .free
    }
}
