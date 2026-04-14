
import SwiftUI

extension ShapeStyle where Self == Color {
    // Dynamic colours that change depending on light/dark mode preference
    static var dynamicBlack: Color { Color("black_for_light") }

    // Static colours
    static var placeholderBackground: Color { Color(red: 208/255, green: 58/255, blue: 32/255) }
}

extension Color {
    // Dynamic colours that change depending on light/dark mode preference
    static let dynamicBlack = Color("black_for_light")

    // Static colours
    static let placeholderBackground: Color = Color(red: 208/255, green: 58/255, blue: 32/255)
}
