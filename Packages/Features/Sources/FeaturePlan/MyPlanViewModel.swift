import Foundation
import Observation
import Domain

@Observable
@MainActor
final class MyPlanViewModel {
    let onShowSummary: () -> Void
    let onBrowse: () -> Void
    private let planStore: PlanStore

    var places: [Place] { planStore.itinerary }
    var summary: TripSummary { TripSummaryCalculator.calculate(places, startTime: .nineAM) }
    var exceedsTenHours: Bool { summary.exceedsTenHours }
    var lastRemoved: (place: Place, index: Int)? { planStore.lastRemoved }

    func move(from source: IndexSet, to destination: Int) {
        planStore.move(from: source, to: destination)
    }

    func remove(at offsets: IndexSet) {
        planStore.remove(at: offsets)
    }

    func undoRemove() {
        planStore.undoLastRemove()
    }

    func showSummary() { onShowSummary() }
    func browse() { onBrowse() }

    init(planStore: PlanStore, onShowSummary: @escaping () -> Void, onBrowse: @escaping () -> Void) {
        self.planStore = planStore
        self.onShowSummary = onShowSummary
        self.onBrowse = onBrowse
    }
}
