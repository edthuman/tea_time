import SwiftUI

struct FormButtonName: View {
    @Binding var name: String
    let textColour: Color
    let backgroundColour: Color
    
    var body: some View {
        TextField("Name", text: $name)
            .multilineTextAlignment(.center)
            .foregroundStyle(textColour)
            .fontWeight(.bold)
            .padding(20)
            .background(
                backgroundColour,
                in: RoundedRectangle(cornerRadius: 12)
            )
    }
}
