import Testing
import Foundation
@testable import Domain

private typealias Category = Domain.Category

// MARK: - Shared fixtures

private func makePlace(
    id: String = "t1",
    name: String = "Test Place",
    category: Category = .landmark,
    duration: Int = 60,
    priceLevel: PriceLevel = .two,
    description: String = "A test place"
) -> Place {
    Place(
        id: id,
        name: name,
        category: category,
        rating: 4.0,
        imageURL: nil,
        estimatedDurationMin: duration,
        distanceKm: 1.0,
        description: description,
        openingHours: "9 AM – 6 PM",
        priceLevel: priceLevel,
        tags: []
    )
}

private var fixedStart: Date {
    var c = DateComponents()
    c.year = 2025; c.month = 1; c.day = 1; c.hour = 9; c.minute = 0; c.second = 0
    return Calendar.current.date(from: c)!
}

// MARK: - TripSummaryCalculatorTests

struct TripSummaryCalculatorTests {

    @Test func emptyPlan() {
        let s = TripSummaryCalculator.calculate([], startTime: fixedStart)
        #expect(s.totalStops == 0)
        #expect(s.totalDurationMin == 0)
        #expect(s.startTime == s.endTime)
        #expect(!s.exceedsTenHours)
    }

    @Test func singleStop60Min() {
        let s = TripSummaryCalculator.calculate([makePlace(duration: 60)], startTime: fixedStart)
        #expect(s.totalStops == 1)
        #expect(s.totalDurationMin == 60)
        let expected = fixedStart.addingTimeInterval(60 * 60)
        #expect(s.endTime == expected)
    }

    @Test func twoStopsIncludeOneTravelGap() {
        let places = [makePlace(id: "a", duration: 60), makePlace(id: "b", duration: 90)]
        let s = TripSummaryCalculator.calculate(places, startTime: fixedStart)
        let gap = TripSummaryCalculator.travelGapMin
        #expect(s.totalDurationMin == 60 + gap + 90)
    }

    @Test func perCategoryCount() {
        let places = [
            makePlace(id: "l1", category: .landmark),
            makePlace(id: "l2", category: .landmark),
            makePlace(id: "c1", category: .cafe)
        ]
        let s = TripSummaryCalculator.calculate(places, startTime: fixedStart)
        #expect(s.perCategoryCount[.landmark] == 2)
        #expect(s.perCategoryCount[.cafe] == 1)
        #expect(s.perCategoryCount[.restaurant] == nil)
    }

    // Aggregation rule: average of numeric values, rounded to nearest integer.
    // (2 + 2 + 3) / 3 = 2.33 → rounds to 2 → .two
    @Test func totalCostAverageRounded() {
        let places = [
            makePlace(id: "a", priceLevel: .two),
            makePlace(id: "b", priceLevel: .two),
            makePlace(id: "c", priceLevel: .three)
        ]
        let s = TripSummaryCalculator.calculate(places, startTime: fixedStart)
        #expect(s.totalCostLevel == .two)
    }

    @Test func justUnderTenHours() {
        // 2 × 292 min + 15 gap = 599 min
        let places = [makePlace(id: "a", duration: 292), makePlace(id: "b", duration: 292)]
        let s = TripSummaryCalculator.calculate(places, startTime: fixedStart)
        #expect(s.totalDurationMin == 599)
        #expect(!s.exceedsTenHours)
    }

    @Test func justOverTenHours() {
        // 2 × 293 min + 15 gap = 601 min
        let places = [makePlace(id: "a", duration: 293), makePlace(id: "b", duration: 293)]
        let s = TripSummaryCalculator.calculate(places, startTime: fixedStart)
        #expect(s.totalDurationMin == 601)
        #expect(s.exceedsTenHours)
    }

    @Test func travelGapConstantIs15() {
        #expect(TripSummaryCalculator.travelGapMin == 15)
    }
}

// MARK: - PlaceFilterTests

struct PlaceFilterTests {

    private let allPlaces: [Place] = [
        makePlace(id: "p1", name: "Amber Fort",    category: .landmark,   description: "Majestic hillfort"),
        makePlace(id: "p2", name: "Hawa Mahal",    category: .landmark,   description: "Palace of Winds"),
        makePlace(id: "p3", name: "Jantar Mantar", category: .landmark,   description: "UNESCO World Heritage Site"),
        makePlace(id: "p4", name: "Tapri Central", category: .cafe,       description: "Famous for masala chai"),
        makePlace(id: "p5", name: "Bar Palladio",  category: .restaurant, description: "Italian restaurant"),
    ]

    @Test func categoryOnly() {
        let results = PlaceFilter.filter(allPlaces, category: .landmark, search: "")
        #expect(results.count == 3)
        #expect(results.allSatisfy { $0.category == .landmark })
    }

    @Test func searchByName() {
        let results = PlaceFilter.filter(allPlaces, category: .all, search: "Amber")
        #expect(results.count == 1)
        #expect(results.first?.name == "Amber Fort")
    }

    @Test func searchByDescription() {
        let results = PlaceFilter.filter(allPlaces, category: .all, search: "UNESCO")
        #expect(results.count == 1)
        #expect(results.first?.name == "Jantar Mantar")
    }

    @Test func combinedCategoryAndSearch() {
        let results = PlaceFilter.filter(allPlaces, category: .cafe, search: "chai")
        #expect(results.count == 1)
        #expect(results.first?.name == "Tapri Central")
    }

    @Test func caseInsensitive() {
        let results = PlaceFilter.filter(allPlaces, category: .all, search: "amber")
        #expect(results.count == 1)
        #expect(results.first?.name == "Amber Fort")
    }

    @Test func noMatch() {
        let results = PlaceFilter.filter(allPlaces, category: .all, search: "xyzxyz")
        #expect(results.isEmpty)
    }

    @Test func allCategoryWithEmptySearchReturnsAll() {
        let results = PlaceFilter.filter(allPlaces, category: .all, search: "")
        #expect(results.count == allPlaces.count)
    }
}

// MARK: - PlanStoreTests

@MainActor
struct PlanStoreTests {

    private func store() -> PlanStore { PlanStore() }
    private var p1: Place { makePlace(id: "p1", name: "Place 1") }
    private var p2: Place { makePlace(id: "p2", name: "Place 2") }
    private var p3: Place { makePlace(id: "p3", name: "Place 3") }

    @Test func addIncreasesCount() {
        let s = store()
        s.add(p1)
        #expect(s.count == 1)
        #expect(s.contains(p1))
    }

    @Test func noDuplicates() {
        let s = store()
        s.add(p1); s.add(p1)
        #expect(s.count == 1)
    }

    @Test func removeDecreasesCount() {
        let s = store()
        s.add(p1)
        s.remove(p1)
        #expect(s.count == 0)
        #expect(!s.contains(p1))
    }

    @Test func moveChangesOrder() {
        let s = store()
        s.add(p1); s.add(p2); s.add(p3)
        s.move(from: IndexSet(integer: 0), to: 3)
        #expect(s.itinerary == [p2, p3, p1])
    }

    @Test func removeAll() {
        let s = store()
        s.add(p1); s.add(p2)
        s.removeAll()
        #expect(s.count == 0)
    }

    @Test func undoLastRemoveRestoresPlace() {
        let s = store()
        s.add(p1); s.add(p2)
        s.remove(p1)
        #expect(s.lastRemoved?.place == p1)
        s.undoLastRemove()
        #expect(s.contains(p1))
        #expect(s.lastRemoved == nil)
    }
}
