import Foundation

enum Physics {
    static let g: Double = 9.81

    /// Returns acceleration along an incline with angle theta and kinetic friction mu.
    /// a = g(sinθ - μ cosθ); clamped to 0 if friction overcomes gravity component.
    static func inclineAcceleration(theta: Double, mu: Double) -> Double {
        let a = g * (sin(theta) - mu * cos(theta))
        return max(0, a)
    }
}
