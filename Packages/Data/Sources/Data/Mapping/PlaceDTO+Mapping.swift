import Foundation
import Domain

extension PlaceDTO {
    func toPlace() -> Place {
        Place(
            id: id,
            name: name,
            category: Category(rawValue: category) ?? .landmark,
            rating: rating,
            imageURL: URL(string: imageURL),
            estimatedDurationMin: estimatedDurationMin,
            distanceKm: distanceKm,
            description: description,
            openingHours: openingHours,
            priceLevel: PriceLevel(rawValue: priceLevel) ?? .free,
            tags: tags
        )
    }
}
