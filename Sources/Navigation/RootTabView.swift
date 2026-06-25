import SwiftUI

struct RootTabView: View {
    let scope: ApplicationScope
    @Bindable var router: AppRouter

    var body: some View {
        TabView(selection: $router.selectedTab) {
            exploreTab
                .tabItem { Label("Explore", systemImage: "magnifyingglass") }
                .tag(AppTab.explore)

            myPlanTab
                .tabItem { Label("My Plan", systemImage: "list.bullet.rectangle") }
                .badge(scope.planStore.count)
                .tag(AppTab.myPlan)
        }
    }

    private var exploreTab: some View {
        NavigationStack {
            ExploreScopeContainer(parentScope: scope)
                .makeRootView(
                    onSelectPlace: { router.selectPlace($0) },
                    onGoToPlan: { router.goToPlan() }
                )
        }
        .sheet(item: $router.presentedPlace) { place in
            DetailScopeContainer(parentScope: scope)
                .makeView(place: place, onDismiss: { router.dismissDetail() })
        }
    }

    private var myPlanTab: some View {
        NavigationStack(path: $router.planPath) {
            PlanScopeContainer(parentScope: scope)
                .makeRootView(
                    onShowSummary: { router.showSummary() },
                    onBrowse: { router.goToExplore() }
                )
                .navigationDestination(for: PlanRoute.self) { route in
                    switch route {
                    case .summary:
                        SummaryScopeContainer(parentScope: scope).makeView()
                    }
                }
        }
    }
}
