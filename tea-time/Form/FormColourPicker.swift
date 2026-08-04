import SwiftUI

struct FormColourPicker: View {
    let label: String
    @Binding var colour: Color
    
    init(_ label: String, colour: Binding<Color>) {
        self.label = label
        self._colour = colour
    }
    
    var body : some View {
        ColorPicker(label, selection: $colour)
            .padding(.top, 5)
            .padding(.vertical, 10)
    }
}
