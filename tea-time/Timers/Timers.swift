import SwiftUI
import CoreData

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
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            
            VStack {
                Group {
                    ViewThatFits {
                        TimersList(showEditTimerForm: $showEditTimerForm, timers: timers)
                        
                        ScrollView {
                            TimersList(showEditTimerForm: $showEditTimerForm, timers: timers)
                        }
                    }
                }
                .frame(height: screenHeight * 0.94)
                .padding(.bottom, 10)
                
                AddTimerButton()
            }
            .frame(maxWidth: .infinity)
        }
    }
}
