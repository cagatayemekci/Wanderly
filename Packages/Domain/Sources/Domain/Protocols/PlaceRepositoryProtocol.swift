public protocol PlaceRepositoryProtocol: Sendable {
    func loadPlaces() async throws -> [Place]
}
