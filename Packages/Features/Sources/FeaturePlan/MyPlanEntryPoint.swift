import SwiftUI
import Domain

public enum MyPlanEntryPoint {
    @MainActor
    public static func makeView(
        planStore: PlanStore,
        onShowSummary: @escaping () -> Void,
        onBrowse: @escaping () -> Void
    ) -> some View {
        MyPlanView(
            vm: MyPlanViewModel(
                planStore: planStore,
                onShowSummary: onShowSummary,
                onBrowse: onBrowse
            )
        )
    }
}
