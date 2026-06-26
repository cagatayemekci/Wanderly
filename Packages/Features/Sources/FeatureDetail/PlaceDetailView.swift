import SwiftUI
import Domain
import DesignSystem

struct PlaceDetailView: View {
    @State private var vm: PlaceDetailViewModel
    @State private var detent: PresentationDetent = .medium

    init(vm: PlaceDetailViewModel) {
        self._vm = State(initialValue: vm)
    }

    var body: some View {
        VStack(spacing: 0) {
            dragHandle
            if detent == .large {
                expandedContent
                    .transition(.opacity)
            } else {
                peekContent
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: detent)
        .presentationDetents([.medium, .large], selection: $detent)
        .presentationDragIndicator(.hidden)
        .presentationBackground(Color.WL.surface)
        .interactiveDismissDisabled(false)
        .accessibilityLabel(vm.place.name)
    }

    // MARK: - Drag handle

    private var dragHandle: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(red: 0.878, green: 0.812, blue: 0.765))
            .frame(width: 40, height: 5)
            .padding(.top, 12)
            .padding(.bottom, 8)
    }

    // MARK: - Peek state (.medium)

    private var peekContent: some View {
        VStack(spacing: WLSpacing.lg) {
            HStack(alignment: .top, spacing: WLSpacing.md) {
                thumbnail(size: 88, radius: 16)
                VStack(alignment: .leading, spacing: 6) {
                    Text(vm.place.name)
                        .textStyle(.detailTitle)
                        .foregroundStyle(Color.WL.ink900)
                        .lineLimit(2)
                    categoryPill
                    RatingView(rating: vm.place.rating)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, WLSpacing.pageInset)

            peekStatRow

            PrimaryButton(vm.ctaTitle) { vm.togglePlan() }
                .padding(.horizontal, WLSpacing.pageInset)
                .accessibilityLabel(vm.ctaTitle)

            Text("Drag up for details")
                .textStyle(.caption)
                .foregroundStyle(Color.WL.ink400)
                .wlPulse()
        }
        .padding(.bottom, WLSpacing.xl)
    }

    private var peekStatRow: some View {
        HStack(spacing: 0) {
            statCell(icon: "clock", value: WLFormatters.duration(vm.place.estimatedDurationMin))
            Rectangle().fill(Color.WL.border).frame(width: 1, height: 28)
            statCell(icon: "dollarsign.circle", value: vm.place.priceLevel.display)
            Rectangle().fill(Color.WL.border).frame(width: 1, height: 28)
            statCell(icon: "door.left.hand.open", value: openingHoursShort)
        }
        .padding(.horizontal, WLSpacing.pageInset)
    }

    private func statCell(icon: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.WL.primary)
            Text(value)
                .textStyle(.footnote)
                .foregroundStyle(Color.WL.ink600)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Expanded state (.large)

    private var expandedContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heroSection
                VStack(alignment: .leading, spacing: WLSpacing.lg) {
                    Text(vm.place.name)
                        .textStyle(.detailTitle)
                        .foregroundStyle(Color.WL.ink900)

                    RatingView(rating: vm.place.rating)

                    if !vm.place.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: WLSpacing.sm) {
                                ForEach(vm.place.tags, id: \.self) { TagPill($0) }
                            }
                        }
                    }

                    StatTable(rows: [
                        StatRow(label: "Opening Hours", value: vm.place.openingHours),
                        StatRow(label: "Price",         value: vm.place.priceLevel.display),
                        StatRow(label: "Visit Duration", value: WLFormatters.duration(vm.place.estimatedDurationMin)),
                    ])

                    VStack(alignment: .leading, spacing: WLSpacing.sm) {
                        Text("About")
                            .font(.system(size: 15, weight: .bold))
                            .tracking(0.9)
                            .foregroundStyle(Color.WL.ink900)
                        Text(vm.place.description)
                            .textStyle(.bodyMedium)
                            .foregroundStyle(Color.WL.ink600)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal, WLSpacing.pageInset)
                .padding(.top, WLSpacing.lg)
                .padding(.bottom, WLSpacing.xxl)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Divider()
                PrimaryButton(vm.ctaTitle) { vm.togglePlan() }
                    .padding(.horizontal, WLSpacing.pageInset)
                    .padding(.top, WLSpacing.md)
                    .padding(.bottom, WLSpacing.md)
                    .accessibilityLabel(vm.ctaTitle)
            }
            .background(Color.WL.surface)
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: vm.place.imageURL) { phase in
                switch phase {
                case .success(let img): img.resizable().scaledToFill()
                default: vm.place.category.categoryGradient
                }
            }
            .frame(height: 262)
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [Color.white.opacity(0.12), Color.black.opacity(0.14)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            categoryPill
                .padding(.leading, WLSpacing.pageInset)
                .padding(.bottom, WLSpacing.md)
        }
    }

    // MARK: - Shared sub-views

    private func thumbnail(size: CGFloat, radius: CGFloat) -> some View {
        AsyncImage(url: vm.place.imageURL) { phase in
            switch phase {
            case .success(let img): img.resizable().scaledToFill()
            case .failure: vm.place.category.categoryGradient
            default:
                vm.place.category.categoryGradient
                    .overlay(ShimmerOverlay())
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: radius))
    }

    private var categoryPill: some View {
        Text(vm.place.category.displayLabel.uppercased())
            .font(.system(size: 11, weight: .bold))
            .tracking(0.7)
            .foregroundStyle(Color.WL.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
    }

    // MARK: - Helpers

    private var openingHoursShort: String {
        let hours = vm.place.openingHours
        if hours.count > 14 { return String(hours.prefix(14)) + "…" }
        return hours
    }
}
