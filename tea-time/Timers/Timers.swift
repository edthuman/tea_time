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

struct Timers: View {
    @ObservedObject var state = appState
    @State var showEditTimerForm: Bool = false
    @State var showDelete: Bool = false
    let folderId: NSManagedObjectID
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var timers: FetchedResults<Timer>
    
    init (folderId: NSManagedObjectID) {
        self.folderId = folderId
        self.state = appState
        _timers = FetchRequest<Timer>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Timer.timerName, ascending: true)],
            predicate: NSPredicate(format: "folder == %@", folderId)
        )
        
        if getSavedFolderState(as: TimerFormData.self, formType: FormType.Timer) != nil {
            _showEditTimerForm = State(initialValue: true)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                BackButton()
                
                if (!timers.isEmpty) {
                    EditTimersButton()
                }
            }
            .padding(.top, getCommandBarPadding(verticalSizeClass))
            
            GeometryReader { geometry in
                let screenHeight = geometry.size.height
                
                VStack (spacing: 0) {
                    Group {
                        if (timers.isEmpty) {
                            EmptyListMessage(message: "No timers")
                        } else {
                            ViewThatFits {
                                TimersList(showEditTimerForm: $showEditTimerForm, showDelete: $showDelete, timers: timers)
                                
                                ScrollView {
                                    TimersList(showEditTimerForm: $showEditTimerForm, showDelete: $showDelete, timers: timers)
                                }
                            }
                        }
                    }
                    .frame(height: getListHeight(screenHeight))
                    .padding(.bottom, 10)
                    
                    AddTimerButton()
                    .padding(.bottom, getAddButtonPadding(screenHeight))
                }
                .frame(maxWidth: .infinity)
            }
            .sheet(isPresented: $showEditTimerForm) {
                EditTimerForm(isPresented: $showEditTimerForm)
            }
            .alert(isPresented: $showDelete) {
                let timer = state.timerBeingEdited
                
                func hideAlert() {
                    showDelete = false
                }
                
                func deleteTimer() {
                    if let timer = timer {
                        let fileName = getFileName(timer)
                        viewContext.delete(timer)
                        
                        do {
                            try deleteSoundFile(fileName: fileName)
                            try viewContext.save()
                        } catch {
                            // EDTODO - Replace this implementation with code to handle the error appropriately.
                            // fatalError terminates the app and creates a crash log
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }
                
                return Alert(
                    title: Text("You are about to delete \(timer?.timerName ?? "this timer")"),
                    primaryButton: .default(
                        Text("Cancel"),
                        action: hideAlert
                    ),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: deleteTimer
                    )
                )
            }
        }
    }
}
