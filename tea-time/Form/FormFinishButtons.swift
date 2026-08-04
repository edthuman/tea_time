import SwiftUI

struct FormFinishButtons: View {
    @State var save: () -> Void
    @State var cancel: () -> Void
    
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
        }
    }
}
