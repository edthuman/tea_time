import SwiftUI

struct FormNumber: View {
    @Binding var value: String
    
    private func incrementTimeLength() {
        let currentValue = Int(value) ?? 0
        value = "\(currentValue + 1)"
    }
    
    private func decrementTimeLength() {
        let currentValue = Int(value) ?? 0
        
        if currentValue > 0 {
            value = "\(currentValue - 1)"
        }
    }
    
    private func sanitiseNumber(_ timerLength: String) -> String {
        let filtered = timerLength.filter { "0123456789".contains($0) }
        if filtered.isEmpty {
            return "0"
        }
        
        // Removed leading zeroes
        let zeroesRemoved = Int(filtered) ?? 0

        let isTooHigh = zeroesRemoved > 1_000_000
        if isTooHigh {
            return "1000000"
        }
        
        let isTooLow = zeroesRemoved < 0
        if isTooLow {
            return "0"
        }
        return String(zeroesRemoved)
    }
    
    var body: some View {
        Button {
            decrementTimeLength()
        } label: {
            Text("-")
        }
        
        TextField("0", text: $value)
            .onChange(of: value) { oldValue, input in
                value = sanitiseNumber(input)
            }
          .multilineTextAlignment(.center)
          .keyboardType(.numberPad)
          .padding(.leading, 1)
          .padding(.trailing, 1)
          .frame(minWidth: 30, idealWidth: nil, maxWidth: nil)
          .fixedSize()
        
        Button {
            incrementTimeLength()
        } label: {
            Text("+")
        }
    }
}
