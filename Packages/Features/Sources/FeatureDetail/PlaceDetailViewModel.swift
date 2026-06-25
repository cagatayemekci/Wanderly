import Foundation
import Observation
import UIKit
import Domain

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
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } else {
            planStore.add(place)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    init(place: Place, planStore: PlanStore, onDismiss: @escaping () -> Void) {
        self.place = place
        self.planStore = planStore
        self.onDismiss = onDismiss
    }
}
