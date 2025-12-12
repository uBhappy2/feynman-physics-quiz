import SwiftUI

struct OrbitalMechanicsChallenge: View {
    @State private var orbitalSpeed: Double = 7.8
    @State private var orbitalRadius: Double = 1.0
    @State private var isRunning = false
    @State private var angle: Double = 0
    @State private var time: Double = 0
    @State private var showAnswer = false

    let dt: Double = 1.0 / 60.0
    let G: Double = 6.674e-11
    let sunMass: Double = 1.989e30 // kg
    let AU: Double = 1.496e11 // meters

    var orbitalPeriod: Double {
        let r = orbitalRadius * AU
        return 2 * .pi * sqrt((r * r * r) / (G * sunMass))
    }

    var orbitalPeriodYears: Double {
        orbitalPeriod / (365.25 * 24 * 3600)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Astronomy Level 1: Orbital Mechanics")
                        .font(.title2).bold()
                        .padding(.top, 8)
                    Text("Explore Kepler's laws: how orbital speed and radius determine planetary orbits.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    OrbitalCanvas(angle: angle, radius: orbitalRadius, speed: orbitalSpeed)
                        .frame(height: 240)
                        .padding(.vertical)

                    HStack {
                        VStack(alignment: .leading) {
                            Slider(value: $orbitalSpeed, in: 5...35, step: 0.5) {
                                Text("Orbital Speed")
                            }
                            Text("Speed: \(String(format: "%.1f", orbitalSpeed)) km/s")
                            Slider(value: $orbitalRadius, in: 0.4...5, step: 0.1) {
                                Text("Orbital Radius")
                            }
                            Text("Radius: \(String(format: "%.1f", orbitalRadius)) AU")
                        }
                        Spacer()
                        VStack {
                            Button(isRunning ? "Stop" : "Orbit") {
                                if isRunning {
                                    isRunning = false
                                } else {
                                    start()
                                }
                            }
                            .buttonStyle(.borderedProminent)

                            Text("Period: \(String(format: "%.2f", orbitalPeriodYears)) yr")
                            Text("Time: \(String(format: "%.1f", time)) s")
                        }
                    }

                    Divider().padding(.vertical, 8)

                    Group {
                        Text("Feynman Insight: Kepler's Laws")
                            .font(.headline)
                        Text("Planets orbit in ellipses with the Sun at one focus. The orbital period depends on the semi-major axis: T² ∝ a³. This elegant relationship, discovered by Kepler and explained by Newton's gravity, shows how simple mathematics describes the cosmos.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        Link("Learn more: Feynman Lectures Vol. I, Ch. 7", destination: URL(string: "https://www.feynmanlectures.caltech.edu/I_07.html")!)
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                .padding()
            }

            Divider()

            ChallengeCardOrbital(showAnswer: $showAnswer, period: orbitalPeriodYears)
                .padding()
        }
        .onChange(of: isRunning) {
            if isRunning { tick() }
        }
    }

    func start() {
        angle = 0
        time = 0
        isRunning = true
    }

    func tick() {
        guard isRunning else { return }
        let angularVelocity = orbitalSpeed / (orbitalRadius * 149.6) // Convert to rad/s
        angle += angularVelocity * dt * (180 / .pi)
        time += dt

        if time > orbitalPeriod * 0.5 {
            isRunning = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
            tick()
        }
    }
}

struct OrbitalCanvas: View {
    let angle: Double
    let radius: Double
    let speed: Double

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let centerX = w / 2
            let centerY = h / 2

            let scale = min(w, h) * 0.2 / radius
            let theta = angle * .pi / 180
            let planetX = centerX + CGFloat(radius) * scale * cos(theta)
            let planetY = centerY + CGFloat(radius) * scale * sin(theta)

            ZStack {
                // Sun
                Circle()
                    .fill(.yellow)
                    .frame(width: 24, height: 24)
                    .position(x: centerX, y: centerY)
                    .shadow(radius: 4)

                // Orbital path
                Circle()
                    .stroke(.gray.opacity(0.3), lineWidth: 1)
                    .frame(width: CGFloat(radius) * scale * 2, height: CGFloat(radius) * scale * 2)
                    .position(x: centerX, y: centerY)

                // Orbital radius line
                Path { p in
                    p.move(to: CGPoint(x: centerX, y: centerY))
                    p.addLine(to: CGPoint(x: planetX, y: planetY))
                }
                .stroke(.orange.opacity(0.5), lineWidth: 1)

                // Velocity vector (tangent to orbit)
                let vScale: CGFloat = 25
                let vx = -sin(theta) * vScale
                let vy = cos(theta) * vScale
                Path { p in
                    p.move(to: CGPoint(x: planetX, y: planetY))
                    p.addLine(to: CGPoint(x: planetX + vx, y: planetY + vy))
                }
                .stroke(.green, lineWidth: 2)

                // Planet
                Circle()
                    .fill(.blue)
                    .frame(width: 16, height: 16)
                    .position(x: planetX, y: planetY)

                // Legend
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle().fill(.yellow).frame(width: 8, height: 8)
                        Text("Sun").font(.caption)
                    }
                    HStack {
                        Circle().fill(.blue).frame(width: 8, height: 8)
                        Text("Planet").font(.caption)
                    }
                    HStack {
                        Rectangle().fill(.green).frame(width: 12, height: 2)
                        Text("Velocity").font(.caption)
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .position(x: 70, y: 30)
            }
        }
    }
}

struct ChallengeCardOrbital: View {
    @Binding var showAnswer: Bool
    let period: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Challenge: Understand Kepler's Third Law.")
                .font(.headline)
            Text("Question: If you double the orbital radius while keeping the orbital speed the same, what happens to the orbital period?")
            if showAnswer {
                Text("Answer: The period increases by a factor of 2. Since T ∝ r/v, doubling r doubles T (assuming constant v). However, in reality, stable orbits follow T² ∝ r³, so doubling r would increase T by √8 ≈ 2.83.")
                    .foregroundStyle(.green)
            }
            HStack {
                Button("Reveal Answer") { showAnswer = true }
                .buttonStyle(.bordered)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview { OrbitalMechanicsChallenge() }
