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

struct RecordingDeniedAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    var formData: Data?
    
    func body(content: Content) -> some View {
        content
            .alert("Microphone use denied", isPresented: $isPresented) {
                Button("Change settings", role: .cancel) {
                    appState.saveCurrentState()
                    saveFormState(formData: formData)
                    
                    Task {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            await UIApplication.shared.open(url)
                        }
                    }
                }
                
                Button("Cancel recording", role: .destructive) {}
            } message: {
                Text("Tea Time requires microphone access to record audio")
            }
    }
}

extension View {
    func audioTooLongAlert(isPresented: Binding<Bool>) -> some View{
        self.modifier(
            AudioTooLongAlertModifier(isPresented: isPresented)
        )
    }
    
    func recordingDeniedAlert(isPresented: Binding<Bool>, formData: Data?) -> some View{
        self.modifier(
            RecordingDeniedAlertModifier(
                isPresented: isPresented,
                formData: formData
            )
        )
    }
}
