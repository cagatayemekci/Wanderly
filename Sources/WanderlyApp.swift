import SwiftUI

@main
struct WanderlyApp: App {
    @State private var scope = ApplicationScope()
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootTabView(scope: scope, router: router)
        }
    }
}
