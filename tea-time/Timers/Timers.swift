import SwiftUI

let reallyMilkyTea = Color(red: 176/255, green: 155/255, blue: 137/255)
let milkyTea = Color(red: 184/255, green: 145/255, blue:109/255)
let blackTea = Color(red: 69/255, green: 42/255, blue: 22/255)
let homeButtonColor: Color = Color(red: 69/255, green: 42/255, blue: 22/255)

struct BackButton: View {
    var body: some View {
        ZStack (alignment: .trailing){
            Button {
                Task {
                    appState.backToHome()
                }
            } label: {
                Text("🏡 Home")
                    .foregroundStyle(Color.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.leading, 20)
    }
}

func setTimer(_ timer: String?) {
    appState.setTimer(timer)
}

struct Timers: View {
    @State var showEditTimerForm: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Timer.timerName, ascending: true)],
        animation: .default
    )
    private var timers: FetchedResults<Timer>
    
    var body: some View {
        VStack (spacing: 20) {
            TimersList(showEditTimerForm: $showEditTimerForm, timers: timers)
        }
    }
}
