# Feynman's Physics Adventure

An interactive SwiftUI app that brings the spirit of Richard Feynman's lectures to life through hands-on physics simulations and challenges.

## Overview

This app features interactive physics challenges inspired by the [Feynman Lectures on Physics](https://www.feynmanlectures.caltech.edu/). Each challenge combines real-time simulations with educational insights, helping users understand fundamental physics concepts through experimentation.

## Features

### Mechanics Zone

Four progressive physics challenges that build understanding from basic forces to complex motion:

#### Level 1: Ramp Simulator
- **Concept**: Forces, friction, and acceleration on inclined planes
- **Interactive Controls**: Adjust angle, friction coefficient (μ), and mass
- **Challenge**: Configure the ramp to reach the target in the shortest time
- **Key Insight**: Understand why mass doesn't affect acceleration on a frictionless ramp
- **Learn More**: [Feynman Lectures Vol. I, Ch. 5](https://www.feynmanlectures.caltech.edu/I_05.html)

#### Level 2: Projectile Motion
- **Concept**: Parabolic trajectories and independence of motion components
- **Interactive Controls**: Adjust launch angle and initial speed
- **Challenge**: Find the angle that achieves maximum range
- **Key Insight**: Horizontal and vertical motion are independent; 45° gives maximum range in vacuum
- **Learn More**: [Feynman Lectures Vol. I, Ch. 9](https://www.feynmanlectures.caltech.edu/I_09.html)

#### Level 3: Pendulum Period
- **Concept**: Simple harmonic motion and energy conservation
- **Interactive Controls**: Adjust pendulum length and initial angle
- **Challenge**: Predict how period changes with length
- **Key Insight**: Period T = 2π√(L/g) depends only on length and gravity, not mass or amplitude
- **Learn More**: [Feynman Lectures Vol. I, Ch. 21](https://www.feynmanlectures.caltech.edu/I_21.html)

#### Level 4: Circular Motion
- **Concept**: Centripetal acceleration and circular dynamics
- **Interactive Controls**: Adjust speed and radius
- **Challenge**: Understand how centripetal acceleration depends on v² and 1/r
- **Key Insight**: Constant speed ≠ constant velocity; acceleration always points toward center
- **Learn More**: [Feynman Lectures Vol. I, Ch. 7](https://www.feynmanlectures.caltech.edu/I_07.html)

## Getting Started

### Requirements
- iOS 18.5+ or macOS 15.4+
- Xcode 16.4+
- Swift 5.0+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/uBhappy2/feynman-physics-quiz.git
cd feynman-physics-quiz
```

2. Open the project in Xcode:
```bash
open PhysicsAdventure.xcodeproj
```

3. Select a target (iPhone Simulator, iPad, or Mac) and press Run (⌘R)

## Project Structure

```
PhysicsAdventure/
├── PhysicsAdventureApp.swift          # App entry point
├── ContentView.swift                  # Main menu with challenge selection
├── MechanicsLevelView.swift           # Level 1: Ramp Simulator
├── ProjectileChallenge.swift          # Level 2: Projectile Motion
├── PendulumChallenge.swift            # Level 3: Pendulum Period
├── CircularMotionChallenge.swift      # Level 4: Circular Motion
├── Physics.swift                      # Physics calculations and utilities
└── Assets.xcassets/                   # App icons and colors
```

## Physics Engine

The app uses simplified physics models to make concepts clear:

- **Incline Acceleration**: `a = g(sin θ - μ cos θ)`
- **Projectile Motion**: Standard kinematic equations with constant acceleration
- **Pendulum**: Small-angle approximation for simple harmonic motion
- **Circular Motion**: Centripetal acceleration `a_c = v²/r`

All simulations run at 60 FPS for smooth real-time visualization.

## Design Philosophy

Following Feynman's teaching approach:
- **Hands-on Learning**: Adjust parameters and see immediate results
- **Intuitive Visualization**: Clear graphics show what's happening
- **Challenge-Based**: Questions encourage deeper thinking
- **Connection to Theory**: Each challenge links to the original Feynman Lectures

## Future Enhancements

- Wave Realm: Interference, diffraction, and wave properties
- Electromagnet Island: Electric fields, magnetic forces, and circuits
- Thermodynamics Zone: Heat, entropy, and statistical mechanics
- Quantum Realm: Probability, uncertainty, and quantum behavior
- Progress tracking and achievement system
- Multiplayer challenges

## Contributing

Contributions are welcome! Please feel free to:
- Report bugs or suggest features via GitHub Issues
- Submit pull requests with improvements
- Add new physics challenges or visualizations

## License

This project is open source and available under the MIT License.

## References

- [The Feynman Lectures on Physics](https://www.feynmanlectures.caltech.edu/) - The complete lectures online
- [Feynman's Teaching Method](https://en.wikipedia.org/wiki/Feynman_Technique) - Learn about his approach to physics education

## Acknowledgments

This app is inspired by Richard Feynman's legendary approach to physics education, emphasizing understanding over memorization and the joy of discovery.

---

**Built with SwiftUI** | **Physics-Driven Learning** | **Inspired by Feynman**
