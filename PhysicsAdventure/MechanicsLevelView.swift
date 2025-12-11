import SwiftUI

struct MechanicsLevelView: View {
    @State private var angleDeg: Double = 20
    @State private var mu: Double = 0.05
    @State private var mass: Double = 1.0
    @State private var isRunning = false

    @State private var v: Double = 0        // m/s
    @State private var x: Double = 0        // meters along ramp
    @State private var targetReached = false
    @State private var showAnswer = false

    let rampLength: Double = 5.0 // meters, virtual
    let dt: Double = 1.0 / 60.0

    var theta: Double { angleDeg * .pi / 180.0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Mechanics Level 1: Ramp Speed Challenge")
                    .font(.title2).bold()
                    .padding(.top, 8)
                Text("Can you configure the ramp so the block reaches the target fastest? Then explain why mass doesn't matter (here).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                RampCanvas(angleDeg: angleDeg, progress: x / rampLength)
                    .frame(height: 220)
                    .padding(.vertical)

                HStack {
                    VStack(alignment: .leading) {
                        Slider(value: $angleDeg, in: 5...45, step: 1) {
                            Text("Angle")
                        }
                        Text("Angle: \(Int(angleDeg))°")
                        Slider(value: $mu, in: 0...0.2, step: 0.01) {
                            Text("Friction μ")
                        }
                        Text("Friction μ: \(String(format: "%.2f", mu))")
                        Slider(value: $mass, in: 0.5...5, step: 0.5) {
                            Text("Mass")
                        }
                        Text("Mass: \(String(format: "%.1f", mass)) kg")
                    }
                    Spacer()
                    VStack {
                        Button(isRunning ? "Reset" : "Start") {
                            if isRunning {
                                isRunning = false
                                reset()
                            } else {
                                start()
                            }
                        }
                        .buttonStyle(.borderedProminent)

                        Text("Speed: \(String(format: "%.2f", v)) m/s")
                        Text("Distance: \(String(format: "%.2f", x)) m")
                    }
                }

                Divider().padding(.vertical, 8)

                ChallengeCard(targetReached: targetReached,
                              showAnswer: $showAnswer,
                              angleDeg: angleDeg, mu: mu, mass: mass)

                Spacer(minLength: 40)

                Group {
                    Text("Learn More (Feynman‑style insight)")
                        .font(.headline)
                    Text("On a frictionless ramp, the speed at the bottom depends on height drop, not mass. With rolling/shape and friction, details change, but the mass factor cancels in the translational acceleration. That’s why changing mass above doesn’t change acceleration in our model.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    Link("Learn more: Feynman Lectures Vol. I, Ch. 5", destination: URL(string: "https://www.feynmanlectures.caltech.edu/I_05.html")!)
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            .padding()
        }
        .onChange(of: isRunning) { _ in
            if isRunning { tick() }
        }
    }

    func reset() {
        v = 0
        x = 0
        targetReached = false
    }

    func start() {
        reset()
        isRunning = true
    }

    func tick() {
        guard isRunning else { return }
        let a = Physics.inclineAcceleration(theta: theta, mu: mu)
        v += a * dt
        x += v * dt
        if x >= rampLength {
            isRunning = false
            targetReached = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
            tick()
        }
    }
}

struct RampCanvas: View {
    let angleDeg: Double
    let progress: Double // 0...1 along ramp

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let margin: CGFloat = 24
            let rampLen = min(w - 2*margin, h - 2*margin)
            let theta = angleDeg * .pi / 180
            let dx = CGFloat(rampLen) * cos(theta)
            let dy = CGFloat(rampLen) * sin(theta)

            let start = CGPoint(x: margin, y: h - margin)
            let end = CGPoint(x: margin + dx, y: h - margin - dy)

            let blockSize: CGFloat = 24
            let bx = start.x + (end.x - start.x) * progress
            let by = start.y + (end.y - start.y) * progress

            ZStack {
                // Ramp
                Path { p in
                    p.move(to: start)
                    p.addLine(to: end)
                }
                .stroke(.gray, lineWidth: 6)

                // Target flag
                Path { p in
                    p.move(to: end)
                    p.addLine(to: CGPoint(x: end.x, y: end.y - 30))
                    p.addLine(to: CGPoint(x: end.x + 22, y: end.y - 20))
                    p.addLine(to: CGPoint(x: end.x, y: end.y - 10))
                }
                .fill(.orange)

                // Block
                Rectangle()
                    .fill(.blue.opacity(0.9))
                    .frame(width: blockSize, height: blockSize)
                    .rotationEffect(.degrees(-angleDeg))
                    .position(x: bx, y: by)
            }
        }
    }
}

struct ChallengeCard: View {
    let targetReached: Bool
    @Binding var showAnswer: Bool
    let angleDeg: Double
    let mu: Double
    let mass: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Challenge: Reach the target in the shortest time.")
                .font(.headline)
            Text("Question: If you double the MASS while keeping angle and friction the same, what happens to the time to reach the target in this model?")
            if showAnswer {
                Text("Answer: It stays the same. Acceleration along the ramp does not depend on mass in this simplified model (no air resistance; sliding with kinetic friction coefficient μ).")
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

#Preview { MechanicsLevelView() }
