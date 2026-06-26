import SwiftUI
import Domain
import DesignSystem

struct TripSummaryView: View {
    @State private var vm: TripSummaryViewModel
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(vm: TripSummaryViewModel) {
        self._vm = State(initialValue: vm)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: WLSpacing.xl) {
                StylizedMapView(places: vm.places)
                    .frame(height: 158)
                    .padding(.horizontal, WLSpacing.pageInset)

                if !vm.categoryBreakdown.isEmpty {
                    categoryBreakdownRow
                }

                StatTable(rows: [
                    StatRow(label: "Stops",          value: "\(vm.summary.totalStops)"),
                    StatRow(label: "Total Duration", value: WLFormatters.duration(vm.summary.totalDurationMin)),
                    StatRow(label: "Est. Cost",      value: vm.summary.totalCostLevel.display),
                ])
                .padding(.horizontal, WLSpacing.pageInset)

                if !vm.summary.stops.isEmpty {
                    itinerarySection
                }
            }
            .padding(.top, WLSpacing.lg)
            .padding(.bottom, WLSpacing.xxl)
        }
        .background(Color.WL.background)
        .scrollContentBackground(.hidden)
        .navigationTitle("Trip Summary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: vm.shareText) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(Color.WL.primary)
                }
                .accessibilityLabel("Share plan")
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomBar
        }
        .onAppear {
            appeared = true
        }
    }

    // MARK: - Category breakdown

    private var categoryBreakdownRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: WLSpacing.sm) {
                ForEach(vm.categoryBreakdown, id: \.category) { item in
                    Text("\(item.count) \(item.category.displayLabel)")
                        .textStyle(.micro)
                        .foregroundStyle(Color.WL.ink600)
                        .padding(.horizontal, WLSpacing.lg)
                        .padding(.vertical, 9)
                        .background(Color.WL.surface2)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, WLSpacing.pageInset)
        }
    }

    // MARK: - Itinerary section

    private var itinerarySection: some View {
        VStack(alignment: .leading, spacing: WLSpacing.md) {
            Text("Your Itinerary")
                .font(.system(size: 15, weight: .bold))
                .tracking(0.9)
                .foregroundStyle(Color.WL.ink900)
                .padding(.horizontal, WLSpacing.pageInset)

            LazyVStack(spacing: 0) {
                ForEach(Array(vm.summary.stops.enumerated()), id: \.element.place.id) { index, stop in
                    SummaryStopRow(
                        index: index + 1,
                        stop: stop,
                        showConnector: index < vm.summary.stops.count - 1
                    )
                    .padding(.horizontal, WLSpacing.pageInset)
                    .padding(.top, 6)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: (!reduceMotion && !appeared) ? 14 : 0)
                    .animation(
                        WLAnimation.cardEntrance(reduceMotion: reduceMotion).delay(
                            WLAnimation.summaryBaseDelay + Double(index) * WLAnimation.summaryStagger
                        ),
                        value: appeared
                    )
                }
            }
        }
    }

    // MARK: - Bottom sticky bar

    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            ShareLink(item: vm.shareText) {
                Text("Share Plan")
                    .textStyle(.cardTitle)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.WL.primary)
                    .clipShape(RoundedRectangle(cornerRadius: WLRadius.button))
                    .wlCTAShadow()
            }
            .buttonStyle(.plain)
            .padding(.horizontal, WLSpacing.pageInset)
            .padding(.top, WLSpacing.md)
            .padding(.bottom, WLSpacing.md)
        }
        .background(Color.WL.surface)
    }

}
