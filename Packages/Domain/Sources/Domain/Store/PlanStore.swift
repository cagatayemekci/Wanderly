import Foundation
import Observation

@Observable
@MainActor
public final class PlanStore {
    public private(set) var itinerary: [Place] = []
    public private(set) var lastRemoved: (place: Place, index: Int)?

    public init() {}

    public var count: Int { itinerary.count }

    public func contains(_ place: Place) -> Bool {
        itinerary.contains(place)
    }

    public func add(_ place: Place) {
        guard !contains(place) else { return }
        itinerary.append(place)
    }

    public func remove(_ place: Place) {
        guard let index = itinerary.firstIndex(of: place) else { return }
        lastRemoved = (place, index)
        itinerary.remove(at: index)
    }

    public func remove(at offsets: IndexSet) {
        let valid = offsets.filter { $0 < itinerary.count }
        if let first = valid.first {
            lastRemoved = (itinerary[first], first)
        }
        for index in valid.sorted().reversed() {
            itinerary.remove(at: index)
        }
    }

    public func move(from source: IndexSet, to destination: Int) {
        guard source.allSatisfy({ $0 < itinerary.count }),
              destination <= itinerary.count else { return }
        var removed: [Place] = []
        var adjusted = destination
        for index in source.sorted().reversed() {
            removed.insert(itinerary.remove(at: index), at: 0)
            if index < destination { adjusted -= 1 }
        }
        itinerary.insert(contentsOf: removed, at: adjusted)
    }

    public func removeAll() {
        itinerary.removeAll()
        lastRemoved = nil
    }

    public func undoLastRemove() {
        guard let last = lastRemoved else { return }
        let index = min(last.index, itinerary.count)
        itinerary.insert(last.place, at: index)
        lastRemoved = nil
    }
}
