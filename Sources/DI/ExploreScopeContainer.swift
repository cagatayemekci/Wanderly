import SwiftUI
import Domain
import FeatureExplore

struct ExploreScopeContainer: ScopeContainer {
    let parentScope: ApplicationScope

    @MainActor
    func makeRootView(
        onSelectPlace: @escaping (Place) -> Void,
        onGoToPlan: @escaping () -> Void
    ) -> some View {
        ExploreEntryPoint.makeView(
            repository: parentScope.placeRepository,
            planStore: parentScope.planStore,
            onSelectPlace: onSelectPlace,
            onGoToPlan: onGoToPlan
        )
    }
}
