import Testing
import Foundation
@testable import Data
import Domain

@MainActor
struct BundledPlaceRepositoryTests {
    let repository = BundledPlaceRepository()

    @Test func loadsAllPlaces() async throws {
        let places = try await repository.loadPlaces()
        #expect(places.count == 35)
    }

    @Test func categoryMapsCorrectly() async throws {
        let places = try await repository.loadPlaces()
        let amber = try #require(places.first { $0.id == "p1" })
        #expect(amber.category == .landmark)

        let barPalladio = try #require(places.first { $0.id == "p7" })
        #expect(barPalladio.category == .restaurant)

        let tapri = try #require(places.first { $0.id == "p6" })
        #expect(tapri.category == .cafe)
    }

    @Test func priceLevelMapsCorrectly() async throws {
        let places = try await repository.loadPlaces()

        let free = try #require(places.first { $0.priceLevel == .free })
        #expect(free.priceLevel.numericValue == 0)

        let amber = try #require(places.first { $0.id == "p1" })
        #expect(amber.priceLevel == .two)

        let suvarna = try #require(places.first { $0.id == "p31" })
        #expect(suvarna.priceLevel == .four)
    }

    @Test func imageURLsAreValid() async throws {
        let places = try await repository.loadPlaces()
        #expect(places.allSatisfy { $0.imageURL != nil })
    }

    @Test func restaurantDisplaysAsEat() async throws {
        let places = try await repository.loadPlaces()
        let restaurants = places.filter { $0.category == .restaurant }
        #expect(!restaurants.isEmpty)
        #expect(restaurants.allSatisfy { $0.category.displayLabel == "Eat" })
    }
}
