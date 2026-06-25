import SwiftUI
import Domain

struct ExploreScopeContainer: ScopeContainer {
    let parentScope: ApplicationScope

    // TODO: replace with ExploreView(viewModel:)
    @MainActor
    func makeRootView(
        onSelectPlace: @escaping (Place) -> Void,
        onGoToPlan: @escaping () -> Void
    ) -> some View {
        Text("Explore")
    }
}
