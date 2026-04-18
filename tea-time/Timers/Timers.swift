import SwiftUI
import CoreData

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
                Text("🏡")
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
    @ObservedObject var state = appState
    @State var showEditTimerForm: Bool = false
    let folderId: NSManagedObjectID
    
    @FetchRequest var timers: FetchedResults<Timer>
    
    init (folderId: NSManagedObjectID) {
        self.folderId = folderId
        self.state = appState
        _timers = FetchRequest<Timer>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Timer.timerName, ascending: true)],
            predicate: NSPredicate(format: "folder == %@", folderId)
        )
    }
    
    var body: some View {
        VStack (spacing: 20) {
            TimersList(showEditTimerForm: $showEditTimerForm, timers: timers)
        }
        
        AddTimerButton()
    }
}
