import Foundation
import Domain

public final class BundledPlaceRepository: PlaceRepositoryProtocol {
    // Set to true in the app target to show skeleton loading while developing.
    public let simulatesDelay: Bool

    public init(simulatesDelay: Bool = false) {
        self.simulatesDelay = simulatesDelay
    }

    public func loadPlaces() async throws -> [Place] {
        if simulatesDelay {
            try await Task.sleep(for: .seconds(1.5))
        }

        guard let url = Bundle.module.url(forResource: "mock_data", withExtension: "json") else {
            throw RepositoryError.fileNotFound
        }

        do {
            let data = try Foundation.Data(contentsOf: url)
            let response = try JSONDecoder().decode(PlacesResponse.self, from: data)
            return response.places.map { $0.toPlace() }
        } catch let error as DecodingError {
            throw RepositoryError.decodingFailed(error)
        }
    }
}
