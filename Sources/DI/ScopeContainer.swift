@dynamicMemberLookup
protocol ScopeContainer {
    associatedtype Parent
    var parentScope: Parent { get }
}

extension ScopeContainer {
    subscript<T>(dynamicMember keyPath: KeyPath<Parent, T>) -> T {
        parentScope[keyPath: keyPath]
    }
}
