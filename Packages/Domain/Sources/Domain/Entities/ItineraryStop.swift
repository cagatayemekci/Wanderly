import Foundation

public struct ItineraryStop: Sendable {
    public let place: Place
    public let arrival: Date
    public let departure: Date

    public init(place: Place, arrival: Date, departure: Date) {
        self.place = place
        self.arrival = arrival
        self.departure = departure
    }
}
