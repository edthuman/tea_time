import SwiftUI

struct FormFinishButtons: View {
    let save: () -> Void
    let disableSave: Bool
    let cancel: () -> Void
    
    var body: some View {
        HStack {
            Button("Cancel") {
                cancel()
            }
            .foregroundStyle(.red)
            .padding(.trailing, 20)
            
            Button("Confirm") {
                save()
            }
            .disabled(disableSave)
        }
    }
}
