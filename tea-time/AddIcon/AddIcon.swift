import SwiftUICore

struct AddIcon: View {
    var body: some View {
        Image(systemName: "plus")
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.dynamicBlack)
            .frame(width: 36, height: 36)
            .overlay(
                Circle()
                    .stroke(.dynamicBlack, lineWidth: 2)
            )
            .contentShape(Circle())
    }
}
