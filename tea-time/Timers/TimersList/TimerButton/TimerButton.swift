import SwiftUI

struct TimerButton: View {
    let timer: Timer
    let screenWidth = UIScreen.main.bounds.width
    
    var timerName: String {
        timer.timerName ?? ""
    }
    
    var timerLength: Int64 {
        timer.seconds
    }
    
    var body: some View {
         Button {
             Task {
                 await beginTimer(length: Double(timerLength), timer: timer)
             }
        } label: {
            Text(timerName)
                .foregroundStyle(
                    Color(red: timer.textRed, green: timer.textGreen, blue: timer.textBlue))
                .fontWeight(.bold)
                .frame(maxWidth: screenWidth * 0.36)
                .padding(20)
        }
        .background(
            Color(
                red: timer.bgRed, green: timer.bgGreen, blue: timer.bgBlue
            ),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }
}
