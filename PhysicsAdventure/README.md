# Feynman's Physics Adventure — iOS (SwiftUI) Starter

This minimal SwiftUI app includes:
- A **Mechanics Ramp Simulator** level with adjustable angle, friction (μ), and mass.
- A simple **challenge card** prompting conceptual reasoning.

## How to run
1. Open Xcode 15+ and create a new **iOS App (SwiftUI)** project named `PhysicsAdventure`.
2. Replace the auto-generated `App` and `ContentView` files with the files in this folder:
   - `PhysicsAdventureApp.swift`
   - `ContentView.swift`
   - `MechanicsLevelView.swift`
   - `Physics.swift`
3. Build & run on iOS 17+.

## Next steps
- Add more zones (Waves, Electromagnetism) as additional SwiftUI views.
- Track stars/badges using a lightweight model (e.g., `ObservableObject` with `@Published` state).
- Link each level's "Learn More" to the relevant online Feynman Lectures section in your in-app help screen.
