import Foundation

public struct TripSummary: Sendable {
    public let totalStops: Int
    public let totalDurationMin: Int
    public let startTime: Date
    public let endTime: Date
    public let stops: [ItineraryStop]
    public let perCategoryCount: [Category: Int]
    public let totalCostLevel: PriceLevel
    public let exceedsTenHours: Bool

    public init(
        totalStops: Int,
        totalDurationMin: Int,
        startTime: Date,
        endTime: Date,
        stops: [ItineraryStop],
        perCategoryCount: [Category: Int],
        totalCostLevel: PriceLevel,
        exceedsTenHours: Bool
    ) {
        self.totalStops = totalStops
        self.totalDurationMin = totalDurationMin
        self.startTime = startTime
        self.endTime = endTime
        self.stops = stops
        self.perCategoryCount = perCategoryCount
        self.totalCostLevel = totalCostLevel
        self.exceedsTenHours = exceedsTenHours
    }
}
