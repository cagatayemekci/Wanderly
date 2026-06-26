import Testing
import Foundation
@testable import Wanderly
import Domain

// MARK: - Fixture

private func makePlace(id: String = "p1") -> Place {
    Place(
        id: id, name: "Test Place", category: .landmark, rating: 4.0, imageURL: nil,
        estimatedDurationMin: 60, distanceKm: 1.0, description: "desc",
        openingHours: "9–6", priceLevel: .two, tags: []
    )
}

// MARK: - AppRouterTests

@MainActor
struct AppRouterTests {

    @Test func selectPlaceSetsPresentedPlace() {
        let router = AppRouter()
        let place = makePlace()
        router.selectPlace(place)
        #expect(router.presentedPlace == place)
    }

    @Test func dismissDetailClearsPresentedPlace() {
        let router = AppRouter()
        router.selectPlace(makePlace())
        router.dismissDetail()
        #expect(router.presentedPlace == nil)
    }

    @Test func showSummarySetsPlanPath() {
        let router = AppRouter()
        router.showSummary()
        #expect(router.planPath == [.summary])
    }

    @Test func goToExploreChangesTab() {
        let router = AppRouter()
        router.goToPlan()
        router.goToExplore()
        #expect(router.selectedTab == .explore)
    }

    @Test func goToPlanChangesTab() {
        let router = AppRouter()
        router.goToPlan()
        #expect(router.selectedTab == .myPlan)
    }

    @Test func popPlanToRootClearsPath() {
        let router = AppRouter()
        router.showSummary()
        router.popPlanToRoot()
        #expect(router.planPath.isEmpty)
    }
}
