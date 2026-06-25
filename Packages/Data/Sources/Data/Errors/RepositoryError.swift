import Foundation

public enum RepositoryError: Error, LocalizedError {
    case fileNotFound
    case decodingFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "mock_data.json not found in app bundle."
        case .decodingFailed(let error):
            return "Failed to decode places: \(error.localizedDescription)"
        }
    }
}
