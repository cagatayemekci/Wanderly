import SwiftUI
import Domain

public enum TripSummaryEntryPoint {
    @MainActor
    public static func makeView(planStore: PlanStore) -> some View {
        TripSummaryView(
            vm: TripSummaryViewModel(planStore: planStore)
        )
    }
}
