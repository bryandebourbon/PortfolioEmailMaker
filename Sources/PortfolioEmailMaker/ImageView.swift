import SwiftUI

struct ImageView: View {
    let image: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
}

struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}
