import SwiftUI

struct GravitationalLensingChallenge: View {
    @State private var lensStrength: Double = 1.0
    @State private var sourceDistance: Double = 2.0
    @State private var showAnswer = false

    let dt: Double = 1.0 / 60.0

    var deflectionAngle: Double {
        // Approximate deflection angle in arcseconds
        // Stronger lens = more deflection
        return lensStrength * 1.75 * (1 / sourceDistance)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Astronomy Level 3: Gravitational Lensing")
                        .font(.title2).bold()
                        .padding(.top, 8)
                    Text("Explore how massive objects bend light and reveal the universe's hidden mass.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    GravitationalLensingCanvas(lensStrength: lensStrength, sourceDistance: sourceDistance, deflectionAngle: deflectionAngle)
                        .frame(height: 240)
                        .padding(.vertical)

                    HStack {
                        VStack(alignment: .leading) {
                            Slider(value: $lensStrength, in: 0.5...3, step: 0.1) {
                                Text("Lens Mass")
                            }
                            Text("Lens Strength: \(String(format: "%.1f", lensStrength))×")
                            Slider(value: $sourceDistance, in: 0.5...4, step: 0.1) {
                                Text("Source Distance")
                            }
                            Text("Distance: \(String(format: "%.1f", sourceDistance)) Mpc")
                        }
                        Spacer()
                        VStack {
                            Text("Deflection:")
                            Text("\(String(format: "%.2f", deflectionAngle))°")
                                .font(.headline)
                                .foregroundStyle(.blue)
                        }
                    }

                    Divider().padding(.vertical, 8)

                    Group {
                        Text("Feynman Insight: Spacetime Curvature")
                            .font(.headline)
                        Text("Massive objects curve spacetime itself. Light follows the straightest path through curved spacetime, which appears as bending to us. This gravitational lensing effect lets astronomers map dark matter, discover exoplanets, and study the early universe. Einstein's prediction was confirmed during the 1919 solar eclipse.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        Link("Learn more: Feynman Lectures Vol. II, Ch. 42", destination: URL(string: "https://www.feynmanlectures.caltech.edu/II_42.html")!)
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                .padding()
            }

            Divider()

            ChallengeCardLensing(showAnswer: $showAnswer, deflectionAngle: deflectionAngle)
                .padding()
        }
    }
}

struct GravitationalLensingCanvas: View {
    let lensStrength: Double
    let sourceDistance: Double
    let deflectionAngle: Double

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let centerX = w / 2
            let centerY = h / 2

            ZStack {
                // Background stars
                Canvas { context, size in
                    for _ in 0..<30 {
                        let x = CGFloat.random(in: 0..<w)
                        let y = CGFloat.random(in: 0..<h)
                        let sz = CGFloat.random(in: 0.5...2)
                        let path = Path(ellipseIn: CGRect(x: x, y: y, width: sz, height: sz))
                        context.fill(path, with: .color(.white.opacity(0.6)))
                    }
                }

                // Observer
                VStack {
                    HStack {
                        Text("Observer").font(.caption).foregroundStyle(.white)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(12)

                // Light source (distant)
                Circle()
                    .fill(.yellow)
                    .frame(width: 12, height: 12)
                    .position(x: w - 30, y: 30)

                // Gravitational lens (massive object)
                Circle()
                    .fill(.gray.opacity(0.7))
                    .frame(width: CGFloat(lensStrength * 40), height: CGFloat(lensStrength * 40))
                    .position(x: centerX, y: centerY)
                    .shadow(radius: 8)

                // Light rays without lensing (dashed)
                Path { p in
                    p.move(to: CGPoint(x: w - 30, y: 30))
                    p.addLine(to: CGPoint(x: 30, y: h - 30))
                }
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                .foregroundStyle(.yellow.opacity(0.3))

                // Light rays with lensing (bent)
                let deflectionRad = deflectionAngle * .pi / 180
                let bendAmount = sin(deflectionRad) * 80

                Path { p in
                    p.move(to: CGPoint(x: w - 30, y: 30))
                    // Curve toward lens
                    p.addCurve(
                        to: CGPoint(x: 30, y: h - 30),
                        control1: CGPoint(x: centerX + bendAmount, y: centerY - 60),
                        control2: CGPoint(x: centerX - bendAmount, y: centerY + 60)
                    )
                }
                .stroke(.yellow, lineWidth: 2)

                // Einstein ring (if aligned)
                if abs(deflectionAngle) > 0.5 {
                    Circle()
                        .stroke(.cyan.opacity(0.5), lineWidth: 2)
                        .frame(width: 60, height: 60)
                        .position(x: centerX, y: centerY)
                }

                // Annotations
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle().fill(.yellow).frame(width: 8, height: 8)
                        Text("Light Source").font(.caption)
                    }
                    HStack {
                        Circle().fill(.gray).frame(width: 8, height: 8)
                        Text("Lens").font(.caption)
                    }
                    HStack {
                        Rectangle().stroke(.yellow, lineWidth: 1).frame(width: 12, height: 1)
                        Text("Light Path").font(.caption)
                    }
                }
                .padding(8)
                .background(.black.opacity(0.5))
                .cornerRadius(8)
                .foregroundStyle(.white)
                .position(x: 80, y: h - 60)
            }
            .background(.black)
        }
    }
}

struct ChallengeCardLensing: View {
    @Binding var showAnswer: Bool
    let deflectionAngle: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Challenge: Understand gravitational lensing.")
                .font(.headline)
            Text("Question: What happens to the deflection angle if you double the mass of the lens while keeping the source distance the same?")
            if showAnswer {
                Text("Answer: The deflection angle approximately doubles. The deflection angle is proportional to the lens mass and inversely proportional to the distance. This effect is used to map dark matter in galaxy clusters and discover exoplanets.")
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

#Preview { GravitationalLensingChallenge() }
