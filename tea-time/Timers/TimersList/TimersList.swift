import SwiftUI

struct TimersList: View {
    @ObservedObject var state = appState
    @Binding var showEditTimerForm: Bool
    @Binding var showDelete: Bool
    
    let timers: FetchedResults<Timer>
    
    var body: some View {
        VStack (spacing: 20) {
            ForEach(timers) { (timer: Timer) in
                if state.isEditingTimers {
                    HStack {
                        TimerButton(timer: timer)
                        
                        Button {
                            state.setTimerBeingEdited(timer)
                            showEditTimerForm = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundStyle(.blue)
                                .padding(.horizontal, 10)
                        }
                        
                        Button {
                            state.setTimerBeingEdited(timer)
                            showDelete = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                } else {
                    TimerButton(timer: timer)
                }
                
            }
        }
        .frame(maxWidth: .infinity)
    }
}
