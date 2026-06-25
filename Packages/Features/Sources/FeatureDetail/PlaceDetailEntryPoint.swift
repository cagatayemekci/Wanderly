import SwiftUI
import Domain

public enum PlaceDetailEntryPoint {
    @MainActor
    public static func makeView(
        place: Place,
        planStore: PlanStore,
        onDismiss: @escaping () -> Void
    ) -> some View {
        PlaceDetailView(
            vm: PlaceDetailViewModel(
                place: place,
                planStore: planStore,
                onDismiss: onDismiss
            )
        )
    }
}
