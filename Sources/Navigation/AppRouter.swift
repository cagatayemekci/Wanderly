import Observation
import Domain
import Foundation

struct PresentedPlace: Identifiable, Equatable {
    let id: UUID
    let place: Place

    init(place: Place, id: UUID = UUID()) {
        self.id = id
        self.place = place
    }
}

@Observable
@MainActor
final class AppRouter {
    var selectedTab: AppTab = .explore
    var planPath: [PlanRoute] = []
    var presentedPlace: PresentedPlace?

    func selectPlace(_ place: Place) { presentedPlace = PresentedPlace(place: place) }
    func dismissDetail()             { presentedPlace = nil }
    func showSummary()               { planPath = [.summary] }
    func goToExplore()               { selectedTab = .explore }
    func goToPlan()                  { selectedTab = .myPlan }
    func popPlanToRoot()             { planPath = [] }
}
