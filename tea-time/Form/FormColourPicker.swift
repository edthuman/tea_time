import SwiftUI

struct FormColourPicker: View {
    let label: String
    let screenWidth: CGFloat?
    let screenHeight: CGFloat?
    @Binding var colour: Color
    
    init(_ label: String, colour: Binding<Color>, screenWidth: CGFloat?, screenHeight: CGFloat?) {
        self.label = label
        self._colour = colour
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
    }
    
    var body : some View {
        ColorPicker(label, selection: $colour)
            .frame(width: screenWidth != nil ? screenWidth! * 0.45 : 200)
            .padding(.vertical, (screenHeight ?? 0) > 500 ? 10 : 6)
    }
}
