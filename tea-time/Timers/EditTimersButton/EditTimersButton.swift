import SwiftUI

struct EditTimersButton: View {
    @ObservedObject var state = appState
 
    private func toggleIsEditingTimers() {
        let isEditingTimers = !appState.isEditingTimers
        appState.setIsEditingTimers(isEditingTimers)
    }
    
    var body: some View {
        ZStack (alignment: .trailing){
            Button {
                toggleIsEditingTimers()
            } label: {
                if (state.isEditingTimers) {
                    Image(systemName: "arrow.uturn.backward")
                        .foregroundStyle(.blue)
                } else {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(.blue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }.padding(.trailing, 20)
    }
}
