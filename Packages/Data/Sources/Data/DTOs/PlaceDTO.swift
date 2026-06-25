import Foundation

struct PlaceDTO: Decodable {
    let id: String
    let name: String
    let category: String
    let rating: Double
    let imageURL: String
    let estimatedDurationMin: Int
    let distanceKm: Double
    let description: String
    let openingHours: String
    let priceLevel: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, category, rating, description, tags
        case imageURL             = "image_url"
        case estimatedDurationMin = "estimated_duration_min"
        case distanceKm           = "distance_km"
        case openingHours         = "opening_hours"
        case priceLevel           = "price_level"
    }
}
