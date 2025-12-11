import SwiftUI

struct CircularMotionChallenge: View {
    @State private var speed: Double = 10
    @State private var radius: Double = 2.0
    @State private var isRunning = false
    @State private var angle: Double = 0
    @State private var time: Double = 0
    @State private var showAnswer = false

    let dt: Double = 1.0 / 60.0
    let g: Double = 9.81

    var centripetal: Double {
        (speed * speed) / radius
    }

    var period: Double {
        2 * .pi * radius / speed
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Mechanics Level 4: Circular Motion")
                        .font(.title2).bold()
                        .padding(.top, 8)
                    Text("Explore centripetal acceleration and how it depends on speed and radius.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    CircularMotionCanvas(angle: angle, radius: radius, speed: speed)
                        .frame(height: 240)
                        .padding(.vertical)

                    HStack {
                        VStack(alignment: .leading) {
                            Slider(value: $speed, in: 5...25, step: 1) {
                                Text("Speed")
                            }
                            Text("Speed: \(String(format: "%.1f", speed)) m/s")
                            Slider(value: $radius, in: 1...4, step: 0.5) {
                                Text("Radius")
                            }
                            Text("Radius: \(String(format: "%.1f", radius)) m")
                        }
                        Spacer()
                        VStack {
                            Button(isRunning ? "Stop" : "Spin") {
                                if isRunning {
                                    isRunning = false
                                } else {
                                    start()
                                }
                            }
                            .buttonStyle(.borderedProminent)

                            Text("a_c: \(String(format: "%.1f", centripetal)) m/s²")
                            Text("Period: \(String(format: "%.2f", period)) s")
                        }
                    }

                    Divider().padding(.vertical, 8)

                    Group {
                        Text("Feynman Insight: Centripetal Force")
                            .font(.headline)
                        Text("An object moving in a circle at constant speed is accelerating toward the center. This centripetal acceleration a = v²/r requires a net force F = ma pointing inward. This force can come from tension, gravity, friction, or normal force. Understanding this distinction—between speed (constant) and velocity (changing direction)—is fundamental to mechanics.")
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

            ChallengeCardCircular(showAnswer: $showAnswer, centripetal: centripetal)
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
        let angularVelocity = speed / radius
        angle += angularVelocity * dt * (180 / .pi)
        time += dt

        if time > period * 3 {
            isRunning = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
            tick()
        }
    }
}

struct CircularMotionCanvas: View {
    let angle: Double
    let radius: Double
    let speed: Double

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let centerX = w / 2
            let centerY = h / 2

            let scale = min(w, h) * 0.25 / radius
            let theta = angle * .pi / 180
            let objX = centerX + CGFloat(radius) * scale * cos(theta)
            let objY = centerY + CGFloat(radius) * scale * sin(theta)

            ZStack {
                // Center point
                Circle()
                    .fill(.black)
                    .frame(width: 8, height: 8)
                    .position(x: centerX, y: centerY)

                // Circular path
                Circle()
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                    .frame(width: CGFloat(radius) * scale * 2, height: CGFloat(radius) * scale * 2)
                    .position(x: centerX, y: centerY)

                // Radius line
                Path { p in
                    p.move(to: CGPoint(x: centerX, y: centerY))
                    p.addLine(to: CGPoint(x: objX, y: objY))
                }
                .stroke(.orange.opacity(0.6), lineWidth: 1.5)

                // Velocity vector (tangent)
                let vScale: CGFloat = 30
                let vx = -sin(theta) * vScale
                let vy = cos(theta) * vScale
                Path { p in
                    p.move(to: CGPoint(x: objX, y: objY))
                    p.addLine(to: CGPoint(x: objX + vx, y: objY + vy))
                }
                .stroke(.green, lineWidth: 2)

                // Centripetal acceleration vector (toward center)
                let aScale: CGFloat = 20
                let ax = -cos(theta) * aScale
                let ay = -sin(theta) * aScale
                Path { p in
                    p.move(to: CGPoint(x: objX, y: objY))
                    p.addLine(to: CGPoint(x: objX + ax, y: objY + ay))
                }
                .stroke(.red, lineWidth: 2)

                // Object
                Circle()
                    .fill(.blue)
                    .frame(width: 20, height: 20)
                    .position(x: objX, y: objY)

                // Legend
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Rectangle().fill(.green).frame(width: 12, height: 2)
                        Text("Velocity").font(.caption)
                    }
                    HStack {
                        Rectangle().fill(.red).frame(width: 12, height: 2)
                        Text("Acceleration").font(.caption)
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .position(x: 60, y: 30)
            }
        }
    }
}

struct ChallengeCardCircular: View {
    @Binding var showAnswer: Bool
    let centripetal: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Challenge: Understand centripetal acceleration.")
                .font(.headline)
            Text("Question: If you double the speed while keeping radius constant, how does centripetal acceleration change?")
            if showAnswer {
                Text("Answer: It increases by a factor of 4. Since a_c = v²/r, doubling v multiplies a_c by 2² = 4.")
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

#Preview { CircularMotionChallenge() }
