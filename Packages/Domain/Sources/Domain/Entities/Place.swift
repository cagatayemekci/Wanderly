import Foundation

public struct Place: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let category: Category
    public let rating: Double
    public let imageURL: URL?
    public let estimatedDurationMin: Int
    public let distanceKm: Double
    public let description: String
    public let openingHours: String
    public let priceLevel: PriceLevel
    public let tags: [String]

    public init(
        id: String,
        name: String,
        category: Category,
        rating: Double,
        imageURL: URL?,
        estimatedDurationMin: Int,
        distanceKm: Double,
        description: String,
        openingHours: String,
        priceLevel: PriceLevel,
        tags: [String]
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.rating = rating
        self.imageURL = imageURL
        self.estimatedDurationMin = estimatedDurationMin
        self.distanceKm = distanceKm
        self.description = description
        self.openingHours = openingHours
        self.priceLevel = priceLevel
        self.tags = tags
    }
}
