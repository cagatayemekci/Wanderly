import SwiftUI
import Domain
import DesignSystem

struct StylizedMapView: View {
    let places: [Place]

    private let yPattern: [CGFloat] = [0.60, 0.28, 0.68, 0.22, 0.72, 0.30, 0.62, 0.20]

    private func pinPoints(in size: CGSize) -> [CGPoint] {
        places.enumerated().map { i, _ in
            CGPoint(
                x: size.width  * CGFloat(i + 1) / CGFloat(places.count + 1),
                y: size.height * yPattern[i % yPattern.count]
            )
        }
    }

    var body: some View {
        Canvas { context, size in
            let w = size.width, h = size.height

            // Grid
            let gridShading = GraphicsContext.Shading.color(Color.WL.border.opacity(0.6))
            for i in 1...4 {
                var p = Path()
                p.move(to: CGPoint(x: 0, y: h * CGFloat(i) / 5))
                p.addLine(to: CGPoint(x: w, y: h * CGFloat(i) / 5))
                context.stroke(p, with: gridShading, lineWidth: 0.5)
            }
            for i in 1...5 {
                var p = Path()
                p.move(to: CGPoint(x: w * CGFloat(i) / 6, y: 0))
                p.addLine(to: CGPoint(x: w * CGFloat(i) / 6, y: h))
                context.stroke(p, with: gridShading, lineWidth: 0.5)
            }

            guard !places.isEmpty else { return }
            let pts = pinPoints(in: size)

            // Route
            if pts.count > 1 {
                var route = Path()
                route.move(to: pts[0])
                for i in 1..<pts.count {
                    let p1 = pts[i - 1], p2 = pts[i]
                    let cp1 = CGPoint(x: p1.x * 0.35 + p2.x * 0.65, y: p1.y)
                    let cp2 = CGPoint(x: p1.x * 0.65 + p2.x * 0.35, y: p2.y)
                    route.addCurve(to: p2, control1: cp1, control2: cp2)
                }
                context.stroke(
                    route,
                    with: .color(Color.WL.primary),
                    style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)
                )
            }

            // Pins + labels
            let showAllLabels = places.count <= 5
            for (i, place) in places.enumerated() {
                let isEndpoint = i == 0 || i == places.count - 1
                let center = pts[i]
                let r: CGFloat = isEndpoint ? 9 : 7
                let outer = CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2)

                context.fill(Path(ellipseIn: outer), with: .color(Color.WL.primary))
                if isEndpoint {
                    context.fill(Path(ellipseIn: outer.insetBy(dx: 3.5, dy: 3.5)), with: .color(.white))
                }

                guard showAllLabels || isEndpoint else { continue }
                let name = place.name
                let label = name.count > 14 ? String(name.prefix(12)) + "…" : name
                context.draw(
                    Text(label)
                        .font(.system(size: 9, weight: isEndpoint ? .bold : .semibold))
                        .foregroundColor(isEndpoint ? Color.WL.ink900 : Color.WL.ink600),
                    at: CGPoint(x: center.x, y: center.y + r + 8)
                )
            }
        }
        .background(Color.WL.mapBg)
        .clipShape(RoundedRectangle(cornerRadius: WLRadius.map))
    }
}
