import SwiftUI

struct AddButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.8))
                    .frame(width: 70, height: 70)
                    .shadow(radius: 3)
                
                Image(systemName: "plus")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
        }
    }
}
