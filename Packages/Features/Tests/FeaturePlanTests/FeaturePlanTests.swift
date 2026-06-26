import Testing
import Foundation
@testable import FeaturePlan
import Domain

// MARK: - Fixture

private func makePlace(id: String, duration: Int = 60) -> Place {
    Place(
        id: id, name: "Place \(id)", category: .landmark, rating: 4.0, imageURL: nil,
        estimatedDurationMin: duration, distanceKm: 1.0, description: "desc",
        openingHours: "9–6", priceLevel: .two, tags: []
    )
}

// MARK: - Tests

@MainActor
struct MyPlanViewModelTests {

    private func makeVM(planStore: PlanStore) -> MyPlanViewModel {
        MyPlanViewModel(planStore: planStore, onShowSummary: {}, onBrowse: {})
    }

    @Test func summaryRecomputedOnAdd() {
        let store = PlanStore()
        let vm = makeVM(planStore: store)
        store.add(makePlace(id: "p1", duration: 60))
        #expect(vm.summary.totalStops == 1)
        #expect(vm.summary.totalDurationMin == 60)
    }

    @Test func summaryRecomputedOnRemove() {
        let store = PlanStore()
        let vm = makeVM(planStore: store)
        let p1 = makePlace(id: "p1", duration: 60)
        let p2 = makePlace(id: "p2", duration: 90)
        store.add(p1); store.add(p2)
        #expect(vm.summary.totalStops == 2)
        store.remove(p2)
        #expect(vm.summary.totalStops == 1)
        #expect(vm.summary.totalDurationMin == 60)
    }

    @Test func summaryRecomputedOnMove() {
        let store = PlanStore()
        let vm = makeVM(planStore: store)
        let p1 = makePlace(id: "p1"); let p2 = makePlace(id: "p2"); let p3 = makePlace(id: "p3")
        store.add(p1); store.add(p2); store.add(p3)
        let totalBefore = vm.summary.totalDurationMin
        vm.move(from: IndexSet(integer: 0), to: 3)
        #expect(vm.summary.totalDurationMin == totalBefore)
        #expect(vm.places == [p2, p3, p1])
    }

    @Test func exceedsTenHoursWhenOverThreshold() {
        let store = PlanStore()
        let vm = makeVM(planStore: store)
        // 2 × 293 min + 15 gap = 601 min > 600
        store.add(makePlace(id: "a", duration: 293))
        store.add(makePlace(id: "b", duration: 293))
        #expect(vm.exceedsTenHours)
    }
}
