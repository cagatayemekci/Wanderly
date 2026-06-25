import SwiftUI
import Domain
import DesignSystem

struct ExploreView: View {
    @State private var vm: ExploreViewModel
    @State private var cardsAnimated = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(vm: ExploreViewModel) {
        self._vm = State(initialValue: vm)
    }

    var body: some View {
        @Bindable var vm = vm
        ScrollView {
            LazyVStack(spacing: 12) {
                placeListContent
            }
            .padding(.horizontal, WLSpacing.pageInset)
            .padding(.top, WLSpacing.md)
            .padding(.bottom, WLSpacing.xxl)
        }
        .background(Color.WL.background)
        .safeAreaInset(edge: .top, spacing: 0) {
            header(searchBinding: $vm.searchText)
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { await vm.load() }
        .animation(.easeInOut(duration: 0.25), value: isLoaded)
        .onChange(of: vm.hasLoaded) { _, loaded in
            if loaded && !cardsAnimated { cardsAnimated = true }
        }
    }

    // MARK: - Header (pinned above scroll)

    private func header(searchBinding: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text("Explore Jaipur")
                    .textStyle(.heroTitle)
                    .foregroundStyle(Color.WL.ink900)
                Spacer()
                if vm.planCount > 0 {
                    PlanFAB(count: vm.planCount, action: vm.onGoToPlan)
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                }
            }
            .padding(.horizontal, WLSpacing.pageInset)
            .padding(.top, WLSpacing.lg)
            .padding(.bottom, WLSpacing.md)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: vm.planCount > 0)

            SearchInput(text: searchBinding)
                .padding(.horizontal, WLSpacing.pageInset)
                .padding(.bottom, WLSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: WLSpacing.sm) {
                    ForEach(Domain.Category.allCases, id: \.self) { cat in
                        CategoryChip(
                            label: cat.displayLabel,
                            isSelected: vm.selectedCategory == cat,
                            action: { vm.selectedCategory = cat }
                        )
                    }
                }
                .padding(.horizontal, WLSpacing.pageInset)
                .padding(.vertical, 2)
            }
            .padding(.bottom, WLSpacing.md)

            Rectangle()
                .fill(Color.WL.cardBorder)
                .frame(height: 1)
        }
        .background(Color.WL.background)
    }

    // MARK: - Place list content

    @ViewBuilder
    private var placeListContent: some View {
        switch vm.loadState {
        case .loading:
            ForEach(0..<5, id: \.self) { _ in
                SkeletonCard()
            }

        case .loaded:
            if vm.filteredPlaces.isEmpty {
                emptySearchState
            } else {
                ForEach(Array(vm.filteredPlaces.enumerated()), id: \.element.id) { index, place in
                    PlaceCard(
                        place: place,
                        isAdded: vm.isAdded(place),
                        onTap: { vm.onSelectPlace(place) },
                        onAdd: { vm.addToPlant(place) }
                    )
                    .opacity(cardsAnimated ? 1 : 0)
                    .offset(y: (!reduceMotion && !cardsAnimated) ? 14 : 0)
                    .animation(
                        WLAnimation.cardEntrance(reduceMotion: reduceMotion)
                            .delay(Double(index) * WLAnimation.cardEntranceStagger),
                        value: cardsAnimated
                    )
                }
            }

        case .error(let err):
            EmptyStateView(
                systemImage: "exclamationmark.triangle",
                title: "Something went wrong",
                subtitle: err.localizedDescription,
                ctaTitle: "Try again",
                ctaAction: { Task { await vm.reload() } }
            )
            .frame(maxWidth: .infinity)
            .padding(.top, WLSpacing.xxl)
        }
    }

    private var emptySearchState: some View {
        EmptyStateView(
            systemImage: "magnifyingglass",
            title: "No places found",
            subtitle: "Try a different search or category"
        )
        .frame(maxWidth: .infinity)
        .padding(.top, WLSpacing.xxl)
    }

    private var isLoaded: Bool {
        if case .loaded = vm.loadState { return true }
        return false
    }
}
