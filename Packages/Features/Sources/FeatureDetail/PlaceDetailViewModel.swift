import Foundation
import Observation
import Domain
import DesignSystem

@Observable
@MainActor
final class PlaceDetailViewModel {
    let place: Place
    let onDismiss: () -> Void
    private let planStore: PlanStore

    var isAdded: Bool { planStore.contains(place) }
    var ctaTitle: String { isAdded ? "Remove from Plan" : "Add to Plan" }

    func togglePlan() {
        if isAdded {
            planStore.remove(place)
            WLHaptics.medium()
        } else {
            planStore.add(place)
            WLHaptics.light()
        }
    }

    init(place: Place, planStore: PlanStore, onDismiss: @escaping () -> Void) {
        self.place = place
        self.planStore = planStore
        self.onDismiss = onDismiss
    }
}
