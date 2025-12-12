import SwiftUI

struct StellarEvolutionChallenge: View {
    @State private var mass: Double = 1.0 // Solar masses
    @State private var showAnswer = false
    @State private var selectedStage: Int = 0

    let stages = [
        ("Main Sequence", "Hydrogen fusing in core", "Stable for billions of years", "🟡"),
        ("Red Giant", "Shell burning, expanded", "Cooler, larger, brighter", "🔴"),
        ("White Dwarf", "Core remnant cooling", "Dense, faint, long-lived", "⚪"),
        ("Neutron Star", "Extreme compression", "Incredibly dense, pulsing", "🤍"),
        ("Black Hole", "Infinite density", "Event horizon, no escape", "⚫")
    ]

    var lifespan: Double {
        // Approximate main sequence lifetime in billions of years
        // L ∝ M^3.5, so t ∝ M/L ∝ M^(-2.5)
        let sunLifespan = 10.0
        return sunLifespan * pow(mass, -2.5)
    }

    var luminosity: Double {
        // L ∝ M^3.5
        return pow(mass, 3.5)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Astronomy Level 2: Stellar Evolution")
                        .font(.title2).bold()
                        .padding(.top, 8)
                    Text("Explore how stellar mass determines a star's life cycle and fate.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    StellarDiagramCanvas(mass: mass, luminosity: luminosity)
                        .frame(height: 240)
                        .padding(.vertical)

                    StellarControlsView(mass: $mass, luminosity: luminosity, lifespan: lifespan)

                    Divider().padding(.vertical, 8)

                    StellarStagesView(stages: stages, selectedStage: $selectedStage)
                        .padding()

                    StellarInsightView()
                }
                .padding()
            }

            Divider()

            ChallengeCardStellar(showAnswer: $showAnswer, mass: mass)
                .padding()
        }
    }
}

struct StellarDiagramCanvas: View {
    let mass: Double
    let luminosity: Double

    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [.black, .blue.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                Text("Hertzsprung-Russell Diagram")
                    .font(.caption)
                    .foregroundStyle(.white)

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mass: \(String(format: "%.1f", mass)) M☉")
                            .font(.caption)
                            .foregroundStyle(.white)
                        Text("Luminosity: \(String(format: "%.1f", luminosity)) L☉")
                            .font(.caption)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 8) {
                            Circle().fill(.yellow).frame(width: 12, height: 12)
                            Text("Your Star").font(.caption2).foregroundStyle(.white)
                        }
                    }

                    Spacer()

                    VStack(alignment: .center, spacing: 8) {
                        Circle()
                            .fill(.yellow)
                            .frame(width: 20, height: 20)
                            .shadow(radius: 4)
                        
                        Text("Main\nSequence")
                            .font(.caption2)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .background(.black.opacity(0.3))
                .cornerRadius(8)

                Spacer()

                HStack {
                    Text("Cool ← Temperature → Hot")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct ChallengeCardStellar: View {
    @Binding var showAnswer: Bool
    let mass: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Challenge: Understand stellar lifetimes.")
                .font(.headline)
            Text("Question: A star with 10 times the Sun's mass burns how many times faster?")
            if showAnswer {
                Text("Answer: About 1000 times faster. Luminosity scales as M^3.5, so a 10 M☉ star is ~3162 times more luminous. With only ~10 times more fuel, it burns ~316 times faster. Its main sequence lifetime is ~30 million years vs. the Sun's 10 billion years.")
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

struct StellarStagesView: View {
    let stages: [(String, String, String, String)]
    @Binding var selectedStage: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Stellar Evolution Stages")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(0..<stages.count, id: \.self) { index in
                    StellarStageButton(stage: stages[index], isSelected: selectedStage == index, action: { selectedStage = index })
                }
            }

            if selectedStage < stages.count {
                VStack(alignment: .leading, spacing: 8) {
                    Text(stages[selectedStage].0).font(.headline)
                    Text(stages[selectedStage].2).font(.footnote).foregroundStyle(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

struct StellarStageButton: View {
    let stage: (String, String, String, String)
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(stage.3).font(.title3)
                VStack(alignment: .leading, spacing: 2) {
                    Text(stage.0).font(.subheadline).bold()
                    Text(stage.1).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.blue)
                }
            }
            .padding(8)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
        .foregroundStyle(.primary)
    }
}

struct StellarControlsView: View {
    @Binding var mass: Double
    let luminosity: Double
    let lifespan: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Slider(value: $mass, in: 0.5...20, step: 0.5) {
                    Text("Stellar Mass")
                }
                Text("Mass: \(String(format: "%.1f", mass)) M☉")
                Text("Luminosity: \(String(format: "%.1f", luminosity)) L☉")
                Text("Main Seq. Life: \(String(format: "%.2f", lifespan)) Gyr")
            }
            Spacer()
        }
    }
}

struct StellarInsightView: View {
    var body: some View {
        Group {
            Text("Feynman Insight: Stellar Nucleosynthesis")
                .font(.headline)
            Text("Stars are cosmic furnaces where nuclear fusion creates heavier elements. Massive stars burn hotter and faster, living only millions of years before exploding as supernovae. Low-mass stars like our Sun burn slowly for billions of years. The heavier elements in your body were forged in stars.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            Link("Learn more: Feynman Lectures Vol. I, Ch. 42", destination: URL(string: "https://www.feynmanlectures.caltech.edu/I_42.html")!)
                .font(.caption)
                .foregroundStyle(.blue)
        }
    }
}

#Preview { StellarEvolutionChallenge() }
