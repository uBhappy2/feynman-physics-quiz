import SwiftUI

struct PendulumChallenge: View {
    @State private var lengthMeters: Double = 1.0
    @State private var initialAngleDeg: Double = 30
    @State private var isRunning = false
    @State private var angle: Double = 30
    @State private var angularVelocity: Double = 0
    @State private var time: Double = 0
    @State private var showAnswer = false

    let dt: Double = 1.0 / 60.0
    let g: Double = 9.81

    var period: Double {
        2 * .pi * sqrt(lengthMeters / g)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Mechanics Level 3: Pendulum Period")
                        .font(.title2).bold()
                        .padding(.top, 8)
                    Text("Observe how the period depends on length, not amplitude (for small angles).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    PendulumCanvas(angle: angle, length: lengthMeters)
                        .frame(height: 240)
                        .padding(.vertical)

                    HStack {
                        VStack(alignment: .leading) {
                            Slider(value: $lengthMeters, in: 0.5...2.5, step: 0.1) {
                                Text("Length")
                            }
                            Text("Length: \(String(format: "%.1f", lengthMeters)) m")
                            Slider(value: $initialAngleDeg, in: 5...60, step: 5) {
                                Text("Initial Angle")
                            }
                            Text("Angle: \(Int(initialAngleDeg))°")
                        }
                        Spacer()
                        VStack {
                            Button(isRunning ? "Stop" : "Swing") {
                                if isRunning {
                                    isRunning = false
                                } else {
                                    start()
                                }
                            }
                            .buttonStyle(.borderedProminent)

                            Text("Period: \(String(format: "%.2f", period)) s")
                            Text("Time: \(String(format: "%.2f", time)) s")
                        }
                    }

                    Divider().padding(.vertical, 8)

                    Group {
                        Text("Feynman Insight: Simple Harmonic Motion")
                            .font(.headline)
                        Text("For small angles, a pendulum undergoes simple harmonic motion. The period T = 2π√(L/g) depends only on length and gravity—not on mass or amplitude. This elegant result shows how physics reveals hidden symmetries. Galileo famously observed this by watching a chandelier in a cathedral!")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        Link("Learn more: Feynman Lectures Vol. I, Ch. 21", destination: URL(string: "https://www.feynmanlectures.caltech.edu/I_21.html")!)
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                .padding()
            }

            Divider()

            ChallengeCardPendulum(showAnswer: $showAnswer, period: period)
                .padding()
        }
        .onChange(of: isRunning) {
            if isRunning { tick() }
        }
    }

    func start() {
        angle = initialAngleDeg
        angularVelocity = 0
        time = 0
        isRunning = true
    }

    func tick() {
        guard isRunning else { return }
        let theta = angle * .pi / 180
        let angularAccel = -(g / lengthMeters) * sin(theta)
        angularVelocity += angularAccel * dt
        angle += angularVelocity * (180 / .pi) * dt
        time += dt

        if time > period * 3 {
            isRunning = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
            tick()
        }
    }
}

struct PendulumCanvas: View {
    let angle: Double
    let length: Double

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let pivotX = w / 2
            let pivotY = h * 0.15

            let scale = min(w, h) * 0.3 / length
            let theta = angle * .pi / 180
            let bobX = pivotX + CGFloat(length) * scale * sin(theta)
            let bobY = pivotY + CGFloat(length) * scale * cos(theta)

            ZStack {
                // Pivot point
                Circle()
                    .fill(.black)
                    .frame(width: 8, height: 8)
                    .position(x: pivotX, y: pivotY)

                // String
                Path { p in
                    p.move(to: CGPoint(x: pivotX, y: pivotY))
                    p.addLine(to: CGPoint(x: bobX, y: bobY))
                }
                .stroke(.gray, lineWidth: 2)

                // Bob
                Circle()
                    .fill(.blue)
                    .frame(width: 24, height: 24)
                    .position(x: bobX, y: bobY)

                // Angle arc (for reference)
                Path { p in
                    p.move(to: CGPoint(x: pivotX, y: pivotY + 40))
                    p.addArc(center: CGPoint(x: pivotX, y: pivotY),
                             radius: 40,
                             startAngle: .degrees(90),
                             endAngle: .degrees(90 + angle),
                             clockwise: false)
                }
                .stroke(.orange.opacity(0.5), lineWidth: 1)
            }
        }
    }
}

struct ChallengeCardPendulum: View {
    @Binding var showAnswer: Bool
    let period: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Challenge: Predict the period.")
                .font(.headline)
            Text("Question: If you double the length of the pendulum, how does the period change?")
            if showAnswer {
                Text("Answer: The period increases by a factor of √2 ≈ 1.41. Since T ∝ √L, doubling L multiplies T by √2.")
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

#Preview { PendulumChallenge() }
