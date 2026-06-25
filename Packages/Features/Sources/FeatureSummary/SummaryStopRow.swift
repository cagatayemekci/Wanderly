import SwiftUI
import Domain
import DesignSystem

struct SummaryStopRow: View {
    let index: Int
    let stop: ItineraryStop
    let showConnector: Bool

    var body: some View {
        VStack(spacing: 0) {
            stopCard
            if showConnector {
                TravelGapConnector(label: "~\(TripSummaryCalculator.travelGapMin) min travel")
                    .padding(.vertical, WLSpacing.xs)
            }
        }
    }

    private var stopCard: some View {
        HStack(alignment: .center, spacing: WLSpacing.md) {
            TimelineNode(index: index)

            AsyncImage(url: stop.place.imageURL) { phase in
                switch phase {
                case .success(let img): img.resizable().scaledToFill()
                default: stop.place.category.categoryGradient
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(stop.place.name)
                    .textStyle(.cardTitle)
                    .foregroundStyle(Color.WL.ink900)
                    .lineLimit(1)
                Text(stop.place.category.displayLabel)
                    .textStyle(.bodyMedium)
                    .foregroundStyle(Color.WL.ink600)
                Text(Self.timeFormatter.string(from: stop.arrival))
                    .textStyle(.timelineTime)
                    .foregroundStyle(Color.WL.primary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, WLSpacing.md)
        .padding(.vertical, WLSpacing.md)
        .background(Color.WL.surface)
        .clipShape(RoundedRectangle(cornerRadius: WLRadius.timeline))
        .wlE1Shadow()
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .none; f.timeStyle = .short; return f
    }()
}
