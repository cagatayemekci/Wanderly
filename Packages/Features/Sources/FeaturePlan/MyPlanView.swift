import SwiftUI
import UIKit
import Domain
import DesignSystem

struct MyPlanView: View {
    @State private var vm: MyPlanViewModel
    @State private var showUndo = false
    @State private var undoTask: Task<Void, Never>?

    init(vm: MyPlanViewModel) {
        self._vm = State(initialValue: vm)
    }

    var body: some View {
        ZStack {
            Color.WL.background.ignoresSafeArea()

            if vm.places.isEmpty {
                emptyState
            } else {
                timelineList
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            stickyHeader
                .background(Color.WL.background)
        }
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .bottom) {
            if showUndo, let removed = vm.lastRemoved {
                undoSnackbar(placeName: removed.place.name)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, WLSpacing.xl)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showUndo)
        .onChange(of: vm.places.count) { old, new in
            if new < old { triggerUndo() }
        }
        .onChange(of: vm.exceedsTenHours) { old, new in
            if !old && new {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            }
        }
    }

    // MARK: - Sticky header

    private var stickyHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleRow
            summaryBar
            if vm.exceedsTenHours {
                WarningBanner("Your day exceeds 10 hours. Consider removing a stop.")
                    .padding(.horizontal, WLSpacing.pageInset)
                    .padding(.vertical, WLSpacing.sm)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            Rectangle()
                .fill(Color.WL.cardBorder)
                .frame(height: 1)
        }
        .animation(.easeInOut(duration: 0.25), value: vm.exceedsTenHours)
    }

    private var titleRow: some View {
        HStack(alignment: .center) {
            Text("My Plan")
                .textStyle(.heroTitle)
                .foregroundStyle(Color.WL.ink900)
            Spacer()
            if !vm.places.isEmpty {
                Button(action: vm.showSummary) {
                    Text("View Summary")
                        .textStyle(.footnote)
                        .foregroundStyle(Color.WL.primary)
                }
            }
        }
        .padding(.horizontal, WLSpacing.pageInset)
        .padding(.top, WLSpacing.lg)
        .padding(.bottom, WLSpacing.md)
    }

    private var summaryBar: some View {
        HStack(spacing: 0) {
            summaryCell(value: "\(vm.summary.totalStops)", label: "stops")
            Rectangle().fill(Color.WL.border).frame(width: 1, height: 28)
            summaryCell(value: formatDuration(vm.summary.totalDurationMin), label: "total")
            Rectangle().fill(Color.WL.border).frame(width: 1, height: 28)
            summaryCell(value: timeWindow, label: "time")
        }
        .padding(.horizontal, WLSpacing.pageInset)
        .padding(.vertical, WLSpacing.md)
    }

    private func summaryCell(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .textStyle(.ratingNumber)
                .foregroundStyle(Color.WL.ink900)
            Text(label)
                .textStyle(.caption)
                .foregroundStyle(Color.WL.ink600)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Timeline list

    private var timelineList: some View {
        List {
            ForEach(Array(vm.places.enumerated()), id: \.element.id) { index, place in
                let stop = index < vm.summary.stops.count
                    ? vm.summary.stops[index]
                    : ItineraryStop(place: place, arrival: .nineAM, departure: .nineAM)

                TimelineStopRow(
                    index: index + 1,
                    stop: stop,
                    showConnector: index < vm.places.count - 1
                )
            }
            .onMove { vm.move(from: $0, to: $1) }
            .onDelete { vm.remove(at: $0) }

            Color.clear.frame(height: 20)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.WL.background)
        .environment(\.editMode, .constant(.active))
    }

    // MARK: - Empty state

    private var emptyState: some View {
        EmptyStateView(
            systemImage: "map.fill",
            title: "Your day is a blank canvas",
            subtitle: "Add places from Explore to start planning your perfect day.",
            ctaTitle: "Explore Jaipur",
            ctaAction: vm.browse
        )
    }

    // MARK: - Undo snackbar

    private func undoSnackbar(placeName: String) -> some View {
        HStack(spacing: WLSpacing.md) {
            Text("Removed \"\(placeName)\"")
                .textStyle(.footnote)
                .foregroundStyle(Color.WL.ink900)
                .lineLimit(1)
            Spacer(minLength: 0)
            Button("Undo") {
                vm.undoRemove()
                showUndo = false
                undoTask?.cancel()
            }
            .textStyle(.footnote)
            .foregroundStyle(Color.WL.primary)
        }
        .padding(.horizontal, WLSpacing.lg)
        .padding(.vertical, WLSpacing.md)
        .background(Color.WL.surface)
        .clipShape(RoundedRectangle(cornerRadius: WLRadius.sm))
        .wlE2Shadow()
        .padding(.horizontal, WLSpacing.pageInset)
    }

    // MARK: - Helpers

    private func triggerUndo() {
        showUndo = true
        undoTask?.cancel()
        undoTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            showUndo = false
        }
    }

    private var timeWindow: String {
        "\(Self.tf.string(from: vm.summary.startTime))→\(Self.tf.string(from: vm.summary.endTime))"
    }

    private func formatDuration(_ minutes: Int) -> String {
        let h = minutes / 60, m = minutes % 60
        if h == 0 { return "\(m)min" }
        if m == 0 { return "\(h)h" }
        return "\(h)h \(m)m"
    }

    private static let tf: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .none; f.timeStyle = .short; return f
    }()
}
