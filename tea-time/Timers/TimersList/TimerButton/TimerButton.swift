import SwiftUI

struct TimerButton: View {
    let timer: Timer
    let screenWidth = UIScreen.main.bounds.width
    
    var timerName: String {
        timer.timerName ?? ""
    }
    
    var body: some View {
         Button {
            setTimer(timerName)
        } label: {
            Text(timerName)
                .foregroundStyle(
                    Color(red: timer.textRed, green: timer.textGreen, blue: timer.textBlue))
                .fontWeight(.bold)
                .frame(maxWidth: screenWidth * 0.3)
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
