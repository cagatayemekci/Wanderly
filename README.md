# Wanderly

A native SwiftUI day-planner for exploring Jaipur. Browse 35 curated places, build a personalised itinerary, reorder stops, and review a trip summary with cost and duration estimates.

## Demo

[![Wanderly walkthrough](https://cdn.loom.com/sessions/thumbnails/2f840955ff8a4e35b5cac3901a26499c-with-play.gif)](https://www.loom.com/share/2f840955ff8a4e35b5cac3901a26499c)

▶️ [Watch the walkthrough on Loom](https://www.loom.com/share/2f840955ff8a4e35b5cac3901a26499c)

---

## Setup

**Prerequisites**

| Tool | Version |
|------|---------|
| Xcode | 16+ |
| Tuist | 4.x (`brew install tuist`) |
| Mint | any (`brew install mint`) |

**Steps**

```bash
git clone https://github.com/cagatayemekci/Wanderly.git
cd Wanderly
mint bootstrap          # installs SwiftLint 0.57.1 and SwiftFormat 0.54.6
tuist generate
open Wanderly.xcworkspace
```

Select a simulator and press **Run** (⌘R). No API keys or environment variables needed.

---

## Architecture

The project is split into independent Swift packages managed by Tuist 4. Each package is a separate `.framework` target — chosen over `.staticFramework` to avoid linker conflicts when test targets link the same module.

```
App (Wanderly)
├── Domain          — entities, use cases, PlanStore, protocols
├── Data            — BundledPlaceRepository, JSON decoding
├── DesignSystem    — design tokens, components, haptics
└── Features
    ├── FeatureExplore  — search & filter screen
    ├── FeatureDetail   — place bottom sheet
    ├── FeaturePlan     — itinerary with drag-reorder and undo
    └── FeatureSummary  — trip summary with stats and stylised map
```

**Clean layered architecture**

The dependency graph only flows inward — Features depend on Domain and DesignSystem, never on each other. Data is imported exclusively by the app target and injected downward. Domain has no dependencies at all: it is pure Swift with no framework imports, making it trivial to test and reuse.

```
App → Features → Domain
App → Data     → Domain
App → DesignSystem → Domain
```

Tuist enforces this at the project level — each target explicitly declares its dependencies in `Project.swift`. There is no way to accidentally import a sibling feature or reach across layers; the build simply fails if you try. This also means build times stay fast because Tuist only recompiles targets whose inputs changed.

**MVVM with internal boundaries**

Each feature exposes exactly one thing: a `public enum FeatureXEntryPoint` with a static `makeView(...)` factory. The `ViewModel` and `View` are `internal`. Consumers can't construct or subclass them — the module is a black box with a typed interface.

```swift
// All a caller ever sees:
FeatureExploreEntryPoint.makeView(
    repository: scope.placeRepository,
    planStore:  scope.planStore,
    onSelectPlace: { ... },
    onGoToPlan:    { ... }
)
```

ViewModels use `@Observable` (iOS 17) with `@MainActor` isolation.

**Dependency injection via scope containers**

`ApplicationScope` owns every long-lived object (`PlanStore`, `BundledPlaceRepository`) and is created once at app launch. Each screen has a matching `XScopeContainer` that receives the parent scope, pulls what it needs, and calls the feature entrypoint. There is no service locator, no global state, and no SwiftUI environment threading — dependencies flow explicitly from parent to child through plain Swift initialisers.

**Navigation**

`AppRouter` (`@Observable @MainActor`) is the single source of navigation truth, held in the root view:

- `selectedTab` — Explore / My Plan tab selection
- `presentedPlace: Place?` — drives the detail bottom sheet via `.sheet(item:)`
- `planPath: [PlanRoute]` — `NavigationStack` path for the Plan → Summary push

Feature modules have zero knowledge of navigation. They receive callbacks (`onGoToPlan`, `onSelectPlace`) that the root wires to router mutations — keeping every screen independently previewable and testable.

---

## State Management

`PlanStore` is the single source of truth for the user's itinerary. It lives in `ApplicationScope`, is created once at app launch, and is injected by value into every feature that needs it — no global singleton, no environment object threading through the view tree.

Three features share the same store simultaneously:

| Feature | Reads | Writes |
|---------|-------|--------|
| Explore | `contains(_:)` for "Added" badge | `add(_:)` |
| My Plan | `itinerary`, `lastRemoved` | `move`, `remove`, `undoLastRemove` |
| Summary | `itinerary` for stats + map | — |

**Why `@Observable` over `ObservableObject`**

`@Observable` (iOS 17) tracks access at the property level rather than the object level. A view re-renders only when a property it actually read changes — not whenever any property on the object changes. For `PlanStore`, this means the Summary screen doesn't re-render when `lastRemoved` changes during a swipe-delete in My Plan, even though they share the same instance.

`TripSummary` is not stored state — it is a pure computed value derived from `PlanStore.itinerary` on every access via `TripSummaryCalculator`. No derived state to sync, no risk of stale data.

---

## Tradeoffs & Assumptions

**Travel time heuristic** — `distance_km` in the data is measured from a fixed city origin, not between stops, so real inter-stop travel time cannot be computed. A flat 15-minute gap between each stop is used instead. This is documented in `TripSummaryCalculator` and asserted in tests.

**In-memory state only** — The plan is not persisted between launches. Adding SwiftData persistence would be straightforward given `PlanStore` is the single mutation point, but it was out of scope here.

**Stylised map** — `StylizedMapView` is a SwiftUI `Canvas` illustration, not a real map. Pins are placed at positions derived from the plan order (not GPS coordinates). A real implementation would use MapKit with actual coordinates from the data source.

**Drag-to-reorder** — Uses `List` with `.onMove` and `.environment(\.editMode, .constant(.active))`. SwiftUI's native drag behaviour covers the functional requirement; the lifted-card visual customisation described in the spec was not achievable without a fully custom drag implementation.

**Bundled data** — All 35 places are loaded from a local JSON file with an optional simulated network delay. No real API was integrated.

---

## Tests

41 tests across 5 targets, all deterministic (no network, fixed start time):

| Target | Suite | Tests |
|--------|-------|-------|
| DomainTests | TripSummaryCalculator | 8 |
| DomainTests | PlaceFilter | 7 |
| DomainTests | PlanStore | 6 |
| FeatureExploreTests | ExploreViewModel | 5 |
| FeaturePlanTests | MyPlanViewModel | 4 |
| AppTests | AppRouter | 6 |
| DataTests | BundledPlaceRepository | 5 |

Run all tests: **⌘U** in Xcode, or via the command line:

```bash
make test
```

`make test` runs the aggregate `Wanderly-Workspace` scheme, which Tuist generates to include every test target (DomainTests, DataTests, FeatureExploreTests, FeaturePlanTests, AppTests). Running `⌘U` in Xcode against the same scheme executes them all at once.

---

## Tooling

```bash
make lint       # SwiftLint (warning mode) — also runs on every build
make format     # SwiftFormat — formats all source files in place
make lint-check # SwiftLint strict mode (exits non-zero on any violation)
```

Both tools are version-pinned in `Mintfile` and installed via `mint bootstrap`.

---

## What I'd Do Differently With More Time

- **Persistence** — SwiftData for saving the plan between launches; `PlanStore` is already the single mutation point so the migration would be localised.
- **Real map** — MapKit `Map` with coordinate data; the current `Canvas` illustration is a placeholder.
- **Networking** — Replace `BundledPlaceRepository` with a real API client and proper error/retry handling.
- **iPad layout** — The current layout is portrait-iPhone only; a split-view or adaptive layout would make better use of larger screens.
- **Drag visual** — A custom drag-to-reorder implementation to show the lifted-card rotation and scale effect that `List.onMove` doesn't expose.

---

## A Note on Tooling

Architecture decisions, module boundaries, technology choices, and product thinking in this project are my own. I used [Claude Code](https://claude.ai/code) (Anthropic's AI coding assistant) as a pair programmer throughout development — for implementation, catching edge cases, and iterating on design details faster than I could alone.
