import SwiftUI
import Domain

public struct PlaceCard: View {
    public let place: Place
    public let isAdded: Bool
    public let onTap: () -> Void
    public let onAdd: () -> Void

    public init(
        place: Place,
        isAdded: Bool,
        onTap: @escaping () -> Void,
        onAdd: @escaping () -> Void
    ) {
        self.place = place
        self.isAdded = isAdded
        self.onTap = onTap
        self.onAdd = onAdd
    }

    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                imageSection
                bodySection
            }
            .background(Color.WL.surface)
            .clipShape(RoundedRectangle(cornerRadius: WLRadius.card))
            .overlay(
                RoundedRectangle(cornerRadius: WLRadius.card)
                    .stroke(
                        isAdded ? Color.WL.cardBorderAdded : Color.WL.cardBorder,
                        lineWidth: isAdded ? 1.5 : 1
                    )
            )
            .wlCardShadow()
        }
        .buttonStyle(WLCardButtonStyle())
        .accessibilityLabel(accessibilityDescription)
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: "View details", onTap)
    }

    // MARK: - Image section
    private var imageSection: some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: place.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    place.category.categoryGradient
                        .overlay(
                            Image(systemName: place.category.sfSymbol)
                                .font(.system(size: 32, weight: .light))
                                .foregroundStyle(.white.opacity(0.7))
                        )
                default:
                    place.category.categoryGradient
                        .overlay(shimmerView)
                }
            }
            .frame(height: 158)
            .clipped()
            .overlay(imageGradient)

            CategoryChip(label: place.category.displayLabel, isSelected: true, action: {})
                .padding(10)
        }
        .frame(height: 158)
        .clipped()
    }

    private var imageGradient: some View {
        LinearGradient(
            colors: [.clear, Color.black.opacity(0.30)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Body section
    private var bodySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(place.name)
                .textStyle(.cardTitle)
                .foregroundStyle(Color.WL.ink900)
                .lineLimit(1)

            RatingView(rating: place.rating)

            HStack(alignment: .center, spacing: WLSpacing.sm) {
                durationPill
                Spacer()
                addButton
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
    }

    private var durationPill: some View {
        Text(WLFormatters.duration(place.estimatedDurationMin))
            .textStyle(.footnote)
            .foregroundStyle(Color.WL.ink600)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.WL.surface2)
            .clipShape(Capsule())
    }

    private var addButton: some View {
        Button(action: onAdd) {
            HStack(spacing: 5) {
                Image(systemName: isAdded ? "checkmark" : "plus")
                    .font(.system(size: 12, weight: .bold))
                Text(isAdded ? "Added" : "Add to Plan")
                    .textStyle(.footnote)
            }
            .foregroundStyle(isAdded ? .white : Color.WL.removeText)
            .padding(.horizontal, 14)
            .frame(height: 44)
            .background(isAdded ? Color.WL.primary : Color.WL.primaryTint)
            .clipShape(RoundedRectangle(cornerRadius: WLRadius.addButton))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isAdded ? "Remove \(place.name) from plan" : "Add \(place.name) to plan")
    }

    // MARK: - Shimmer placeholder
    private var shimmerView: some View {
        ShimmerOverlay()
    }

    private var accessibilityDescription: String {
        let stars = String(format: "%.1f", place.rating)
        let duration = WLFormatters.duration(place.estimatedDurationMin)
        return "\(place.name), \(place.category.displayLabel), \(stars) stars, \(duration)"
    }
}

// MARK: - Reusable shimmer overlay
public struct ShimmerOverlay: View {
    public init() {}
    @State private var phase: CGFloat = 0

    public var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: Color.WL.shimmerHighlight.opacity(0.8), location: 0.5),
                    .init(color: .clear, location: 1),
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: w * 2.5)
            .offset(x: -w + phase * w * 3.5)
        }
        .onAppear {
            withAnimation(WLAnimation.shimmer) {
                phase = 1
            }
        }
    }
}
