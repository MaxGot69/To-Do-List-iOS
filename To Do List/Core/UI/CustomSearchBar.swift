import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: Constants.UI.smallSpacing) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(Constants.Colors.secondaryText))
                .font(.system(size: Constants.UI.iconSize))
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(Color(Constants.Colors.primaryText))
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(Constants.Colors.secondaryText))
                        .font(.system(size: Constants.UI.iconSize))
                }
            }
            
            Button(action: {
                // Voice input action
            }) {
                Image(systemName: "mic")
                    .foregroundColor(Color(Constants.Colors.secondaryText))
                    .font(.system(size: Constants.UI.iconSize))
            }
        }
        .padding(.horizontal, Constants.UI.spacing)
        .padding(.vertical, Constants.UI.smallSpacing)
        .background(Color(Constants.Colors.secondaryBackground))
        .cornerRadius(Constants.UI.smallCornerRadius)
    }
}

#Preview {
    CustomSearchBar(text: .constant(""), placeholder: "Поиск задач...")
        .padding()
        .background(Color(Constants.Colors.primaryBackground))
} 