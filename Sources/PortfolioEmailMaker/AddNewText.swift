import SwiftUI

struct AddNewText: View {
    @Binding var newText: String
    var onComplete: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Add New Text")
                .font(.headline)
            TextEditor( text: $newText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Add") {
                onComplete(newText)
            }
            .padding()
            Spacer()
        }
        .padding()
    }
}
