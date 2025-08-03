import SwiftUI

struct CustomCheckbox: View {
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isCompleted ? Color(Constants.Colors.accentYellow) : Color.clear)
                    .frame(width: Constants.UI.checkboxSize, height: Constants.UI.checkboxSize)
                    .overlay(
                        Circle()
                            .stroke(Color(Constants.Colors.accentYellow), lineWidth: 2)
                    )
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomCheckbox(isCompleted: false) {}
        CustomCheckbox(isCompleted: true) {}
    }
    .padding()
    .background(Color(Constants.Colors.primaryBackground))
} 