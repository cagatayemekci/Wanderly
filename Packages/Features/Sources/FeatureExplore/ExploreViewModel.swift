import Foundation
import Observation
import Domain
import DesignSystem

@Observable
@MainActor
final class ExploreViewModel {
    enum LoadState {
        case loading
        case loaded([Place])
        case error(Error)
    }

    var loadState: LoadState = .loading
    private(set) var hasLoaded = false
    var selectedCategory: Domain.Category = .all
    var searchText: String = ""

    var filteredPlaces: [Place] {
        guard case .loaded(let places) = loadState else { return [] }
        return PlaceFilter.filter(places, category: selectedCategory, search: searchText)
    }

    var planCount: Int { planStore.count }

    func isAdded(_ place: Place) -> Bool { planStore.contains(place) }

    func addToPlan(_ place: Place) {
        planStore.add(place)
        WLHaptics.light()
    }

    // Called by .task — skips if data is already available so tab switches don't retrigger fetch
    func load() async {
        switch loadState {
        case .loaded, .error: return
        case .loading: break
        }
        await performFetch()
    }

    // Called by the explicit retry button — always re-fetches
    func reload() async {
        loadState = .loading
        await performFetch()
    }

    private func performFetch() async {
        do {
            let places = try await repository.loadPlaces()
            loadState = .loaded(places)
            hasLoaded = true
        } catch is CancellationError {
            // Task cancelled (tab switch during in-flight load) — leave loadState as .loading
            // so the next .onAppear retries naturally
        } catch {
            loadState = .error(error)
        }
    }

    let onSelectPlace: (Place) -> Void
    let onGoToPlan: () -> Void

    private let repository: any PlaceRepositoryProtocol
    private let planStore: PlanStore

    init(
        repository: any PlaceRepositoryProtocol,
        planStore: PlanStore,
        onSelectPlace: @escaping (Place) -> Void,
        onGoToPlan: @escaping () -> Void
    ) {
        self.repository = repository
        self.planStore = planStore
        self.onSelectPlace = onSelectPlace
        self.onGoToPlan = onGoToPlan
    }
}
