import SwiftUI

struct CustomNavigationBar: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.backward")
                    .foregroundColor(Color("textPrimary"))
                    .font(.system(size: 24))
            }
            
            Text(title)
                .foregroundColor(Color("textPrimary"))
                .font(.system(size: 32, weight: .semibold))
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
} 
