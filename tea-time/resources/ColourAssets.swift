
import SwiftUI

extension ShapeStyle where Self == Color {
    // Black in light mode - white in dark mode
    static var dynamicBlack: Color { Color("black_for_light") }
}

extension Color {
    // Black in light mode - white in dark mode
    static let dynamicBlack = Color("black_for_light")
}
