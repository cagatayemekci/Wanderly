import SwiftUI
import Domain
import FeatureDetail

struct DetailScopeContainer: ScopeContainer {
    let parentScope: ApplicationScope

    @MainActor
    func makeView(place: Place, onDismiss: @escaping () -> Void) -> some View {
        PlaceDetailEntryPoint.makeView(
            place: place,
            planStore: parentScope.planStore,
            onDismiss: onDismiss
        )
    }
}
