import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Feynman's Physics Adventure")
                    .font(.largeTitle).bold()
                    .multilineTextAlignment(.center)
                Text("Sandbox + Challenges inspired by the spirit of the Feynman Lectures")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                VStack(spacing: 12) {
                    Text("Mechanics Zone").font(.headline).foregroundStyle(.secondary)
                    NavigationLink("Level 1: Ramp Simulator") {
                        MechanicsLevelView()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    NavigationLink("Level 2: Projectile Motion") {
                        ProjectileChallenge()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    NavigationLink("Level 3: Pendulum Period") {
                        PendulumChallenge()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    NavigationLink("Level 4: Circular Motion") {
                        CircularMotionChallenge()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }

                NavigationLink("Wave Realm (coming soon)") { PlaceholderView(title: "Wave Realm") }
                    .disabled(true)
                NavigationLink("Electromagnet Island (coming soon)") { PlaceholderView(title: "Electromagnet Island") }
                    .disabled(true)

                Spacer()
            }
            .padding()
        }
    }
}

struct PlaceholderView: View {
    let title: String
    var body: some View {
        VStack { Text(title).font(.title); Text("Work in progress") }
    }
}

#Preview { ContentView() }
