import SwiftUI

struct TimersList: View {
    @ObservedObject var state = appState
    @Binding var showEditTimerForm: Bool
    
    let timers: FetchedResults<Timer>
    
    var body: some View {
        VStack (spacing: 20) {
            ForEach(timers) { (timer: Timer) in
                TimerButton(timer: timer)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
