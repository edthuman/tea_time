import SwiftUI

struct EmptyFoldersList: View {
    @ObservedObject var state = appState
    @State private var isAdding: Bool = false
    
    var body: some View {
        VStack {
            Text("No folders")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.dynamicBlack)
        }
    }
}
