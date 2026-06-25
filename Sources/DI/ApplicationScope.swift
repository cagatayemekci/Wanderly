import Domain
import Data

@MainActor
final class ApplicationScope {
    let placeRepository: any PlaceRepositoryProtocol
    let planStore: PlanStore

    init() {
        placeRepository = BundledPlaceRepository(simulatesDelay: true)
        planStore = PlanStore()
    }
}
