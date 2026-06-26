import Testing
import Foundation
@testable import FeatureExplore
import Domain

private typealias Category = Domain.Category

// MARK: - Mock

private final class MockPlaceRepository: PlaceRepositoryProtocol, @unchecked Sendable {
    var result: Result<[Place], Error> = .success([])
    func loadPlaces() async throws -> [Place] { try result.get() }
}

private struct MockError: Error {}

// MARK: - Fixture

private func makePlace(id: String, category: Category = .landmark, name: String = "Place") -> Place {
    Place(
        id: id, name: name, category: category, rating: 4.0, imageURL: nil,
        estimatedDurationMin: 60, distanceKm: 1.0, description: "desc",
        openingHours: "9–6", priceLevel: .two, tags: []
    )
}

// MARK: - Tests

@MainActor
struct ExploreViewModelTests {

    private func makeVM(places: [Place] = [], error: Error? = nil) -> (ExploreViewModel, PlanStore) {
        let repo = MockPlaceRepository()
        if let error { repo.result = .failure(error) } else { repo.result = .success(places) }
        let store = PlanStore()
        let vm = ExploreViewModel(
            repository: repo,
            planStore: store,
            onSelectPlace: { _ in },
            onGoToPlan: {}
        )
        return (vm, store)
    }

    @Test func loadSuccessSetsLoadedState() async {
        let places = [makePlace(id: "p1"), makePlace(id: "p2")]
        let (vm, _) = makeVM(places: places)
        await vm.load()
        if case .loaded(let result) = vm.loadState {
            #expect(result.count == 2)
        } else {
            Issue.record("Expected .loaded state")
        }
    }

    @Test func loadErrorSetsErrorState() async {
        let (vm, _) = makeVM(error: MockError())
        await vm.load()
        if case .error = vm.loadState { } else {
            Issue.record("Expected .error state")
        }
    }

    @Test func filterByCategory() async {
        let places = [
            makePlace(id: "l1", category: .landmark),
            makePlace(id: "c1", category: .cafe),
            makePlace(id: "c2", category: .cafe),
        ]
        let (vm, _) = makeVM(places: places)
        await vm.load()
        vm.selectedCategory = .cafe
        #expect(vm.filteredPlaces.count == 2)
        #expect(vm.filteredPlaces.allSatisfy { $0.category == .cafe })
    }

    @Test func searchFiltersByName() async {
        let places = [
            makePlace(id: "p1", name: "Amber Fort"),
            makePlace(id: "p2", name: "Hawa Mahal"),
        ]
        let (vm, _) = makeVM(places: places)
        await vm.load()
        vm.searchText = "Amber"
        #expect(vm.filteredPlaces.count == 1)
        #expect(vm.filteredPlaces.first?.name == "Amber Fort")
    }

    @Test func addReflectsInStore() async {
        let place = makePlace(id: "p1")
        let (vm, store) = makeVM(places: [place])
        await vm.load()
        vm.addToPlant(place)
        #expect(store.contains(place))
    }
}
