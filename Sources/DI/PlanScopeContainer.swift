import SwiftUI
import FeaturePlan

struct PlanScopeContainer: ScopeContainer {
    let parentScope: ApplicationScope

    @MainActor
    func makeRootView(
        onShowSummary: @escaping () -> Void,
        onBrowse: @escaping () -> Void
    ) -> some View {
        MyPlanEntryPoint.makeView(
            planStore: parentScope.planStore,
            onShowSummary: onShowSummary,
            onBrowse: onBrowse
        )
    }
}
