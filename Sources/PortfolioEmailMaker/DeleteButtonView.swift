import SwiftUI

struct DeleteButtonView: View {
    let index: Int
    let deleteAction: (Int) -> Void
    
    var body: some View {
        Button(action: {
            deleteAction(index)
        }) {
            Image(systemName: "minus.circle")
                .foregroundColor(.red)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
