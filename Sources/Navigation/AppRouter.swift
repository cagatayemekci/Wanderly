import Observation
import Domain

@Observable
@MainActor
final class AppRouter {
    var selectedTab: AppTab = .explore
    var planPath: [PlanRoute] = []
    var presentedPlace: Place? = nil

    func selectPlace(_ place: Place) { presentedPlace = place }
    func dismissDetail()             { presentedPlace = nil }
    func showSummary()               { planPath = [.summary] }
    func goToExplore()               { selectedTab = .explore }
    func goToPlan()                  { selectedTab = .myPlan }
    func popPlanToRoot()             { planPath = [] }
}
