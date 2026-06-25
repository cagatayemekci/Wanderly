import SwiftUI

struct SummaryScopeContainer: ScopeContainer {
    let parentScope: ApplicationScope

    // TODO: replace with TripSummaryView(viewModel:)
    @MainActor
    func makeView() -> some View {
        Text("Trip Summary")
    }
}
