public enum PlaceFilter {
    public static func filter(
        _ places: [Place],
        category: Category,
        search: String
    ) -> [Place] {
        places.filter { place in
            matchesCategory(place, category: category) &&
            matchesSearch(place, query: search)
        }
    }

    private static func matchesCategory(_ place: Place, category: Category) -> Bool {
        category == .all || place.category == category
    }

    private static func matchesSearch(_ place: Place, query: String) -> Bool {
        guard !query.isEmpty else { return true }
        let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        return place.name.range(of: query, options: options) != nil
            || place.description.range(of: query, options: options) != nil
    }
}
