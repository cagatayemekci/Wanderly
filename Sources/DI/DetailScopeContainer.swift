import SwiftUI
import Domain

struct DetailScopeContainer: ScopeContainer {
    let parentScope: ApplicationScope

    // TODO: replace with PlaceDetailView(viewModel:)
    @MainActor
    func makeView(place: Place) -> some View {
        Text(place.name)
            .padding()
    }
}
