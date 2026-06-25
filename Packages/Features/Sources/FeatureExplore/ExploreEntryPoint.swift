import SwiftUI
import Domain

public enum ExploreEntryPoint {
    @MainActor
    public static func makeView(
        repository: any PlaceRepositoryProtocol,
        planStore: PlanStore,
        onSelectPlace: @escaping (Place) -> Void,
        onGoToPlan: @escaping () -> Void
    ) -> some View {
        ExploreView(
            vm: ExploreViewModel(
                repository: repository,
                planStore: planStore,
                onSelectPlace: onSelectPlace,
                onGoToPlan: onGoToPlan
            )
        )
    }
}
