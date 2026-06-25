import SwiftUI

struct PlanScopeContainer: ScopeContainer {
    let parentScope: ApplicationScope

    // TODO: replace with MyPlanView(viewModel:)
    @MainActor
    func makeRootView(
        onShowSummary: @escaping () -> Void,
        onBrowse: @escaping () -> Void
    ) -> some View {
        Text("My Plan")
    }
}
