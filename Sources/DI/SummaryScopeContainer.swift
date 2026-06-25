import SwiftUI
import FeatureSummary

struct SummaryScopeContainer: ScopeContainer {
    let parentScope: ApplicationScope

    @MainActor
    func makeView() -> some View {
        TripSummaryEntryPoint.makeView(planStore: parentScope.planStore)
    }
}
