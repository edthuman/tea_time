import SwiftUI

struct AudioTooLongAlertModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content
            .alert("Selected audio was too long", isPresented: $isPresented) {
                Button("But I liked that audio... 😞") { }
            } message: {
                Text("Notification sounds cannot be longer than 30 seconds")
            }
    }
}

extension View {
    func audioTooLongAlert(isPresented: Binding<Bool>) -> some View{
        self.modifier(
            AudioTooLongAlertModifier(isPresented: isPresented)
        )
    }
}
