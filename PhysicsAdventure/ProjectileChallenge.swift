import SwiftUI

struct ProjectileChallenge: View {
    @State private var launchAngleDeg: Double = 45
    @State private var launchSpeed: Double = 20
    @State private var isRunning = false
    @State private var time: Double = 0
    @State private var targetHit = false
    @State private var showAnswer = false

    let dt: Double = 1.0 / 60.0
    let g: Double = 9.81
    let targetX: Double = 40 // meters

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Mechanics Level 2: Projectile Motion")
                        .font(.title2).bold()
                        .padding(.top, 8)
                    Text("Launch the projectile to hit the target. What angle gives maximum range?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    ProjectileCanvas(angle: launchAngleDeg, speed: launchSpeed, time: time, targetX: targetX)
                        .frame(height: 240)
                        .padding(.vertical)

                    HStack {
                        VStack(alignment: .leading) {
                            Slider(value: $launchAngleDeg, in: 5...85, step: 1) {
                                Text("Launch Angle")
                            }
                            Text("Angle: \(Int(launchAngleDeg))°")
                            Slider(value: $launchSpeed, in: 10...40, step: 1) {
                                Text("Launch Speed")
                            }
                            Text("Speed: \(String(format: "%.1f", launchSpeed)) m/s")
                        }
                        Spacer()
                        VStack {
                            Button(isRunning ? "Reset" : "Launch") {
                                if isRunning {
                                    isRunning = false
                                    reset()
                                } else {
                                    start()
                                }
                            }
                            .buttonStyle(.borderedProminent)

                            Text("Time: \(String(format: "%.2f", time)) s")
                            if targetHit {
                                Text("🎯 Hit!").foregroundStyle(.green).font(.headline)
                            }
                        }
                    }

                    Divider().padding(.vertical, 8)

                    Group {
                        Text("Feynman Insight: Parabolic Paths")
                            .font(.headline)
                        Text("Projectile motion combines constant horizontal velocity with constant downward acceleration. The path is a parabola. Maximum range occurs at 45° (in vacuum). Real projectiles deviate due to air resistance—a key insight Feynman emphasized about idealized vs. real physics.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        Link("Learn more: Feynman Lectures Vol. I, Ch. 9", destination: URL(string: "https://www.feynmanlectures.caltech.edu/I_09.html")!)
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                .padding()
            }

            Divider()

            ChallengeCardProjectile(targetHit: targetHit, showAnswer: $showAnswer)
                .padding()
        }
        .onChange(of: isRunning) {
            if isRunning { tick() }
        }
    }

    func reset() {
        time = 0
        targetHit = false
    }

    func start() {
        reset()
        isRunning = true
    }

    func tick() {
        guard isRunning else { return }
        time += dt
        let theta = launchAngleDeg * .pi / 180
        let y = launchSpeed * sin(theta) * time - 0.5 * g * time * time
        if y < 0 {
            isRunning = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
            tick()
        }
    }
}

struct ProjectileCanvas: View {
    let angle: Double
    let speed: Double
    let time: Double
    let targetX: Double

    private func calculateTrajectory(theta: Double, speed: Double, scale: CGFloat, margin: CGFloat, h: CGFloat) -> [CGPoint] {
        var points: [CGPoint] = []
        let g: Double = 9.81
        let steps = 100
        for i in 0...steps {
            let t = Double(i) * 0.05
            let x = speed * cos(theta) * t
            let y = speed * sin(theta) * t - 0.5 * g * t * t
            if y >= 0 {
                let px = margin + CGFloat(x) * scale
                let py = h - margin - CGFloat(y) * scale
                points.append(CGPoint(x: px, y: py))
            }
        }
        return points
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let margin: CGFloat = 20
            let scale: CGFloat = (w - 2*margin) / 60 // 60m width

            let theta = angle * .pi / 180
            let g: Double = 9.81

            let points = calculateTrajectory(theta: theta, speed: speed, scale: scale, margin: margin, h: h)

            // Current projectile position
            let x = speed * cos(theta) * time
            let y = speed * sin(theta) * time - 0.5 * g * time * time
            let projX = margin + CGFloat(x) * scale
            let projY = h - margin - CGFloat(y) * scale

            ZStack {
                // Ground
                Rectangle()
                    .fill(.brown.opacity(0.3))
                    .frame(height: 4)
                    .position(x: w/2, y: h - margin)

                // Trajectory
                if points.count > 1 {
                    Path { p in
                        p.move(to: points[0])
                        for point in points.dropFirst() {
                            p.addLine(to: point)
                        }
                    }
                    .stroke(.blue, lineWidth: 2)
                }

                // Target
                Circle()
                    .fill(.orange)
                    .frame(width: 20, height: 20)
                    .position(x: margin + CGFloat(targetX) * scale, y: h - margin)

                // Projectile
                if y >= 0 {
                    Circle()
                        .fill(.red)
                        .frame(width: 12, height: 12)
                        .position(x: projX, y: projY)
                }

                // Launch point
                Circle()
                    .fill(.green)
                    .frame(width: 10, height: 10)
                    .position(x: margin, y: h - margin)
            }
        }
    }
}

struct ChallengeCardProjectile: View {
    let targetHit: Bool
    @Binding var showAnswer: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Challenge: Hit the target at 40m distance.")
                .font(.headline)
            Text("Question: At what angle does a projectile achieve maximum range in a vacuum?")
            if showAnswer {
                Text("Answer: 45°. This is because range = (v²sin(2θ))/g, which is maximized when sin(2θ) = 1, giving θ = 45°.")
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

#Preview { ProjectileChallenge() }
