import SwiftUI

struct ListItemView: View {
    @Binding var item: ListItem
    @Binding var selectedImage: IdentifiableImage?
    
    var body: some View {
        HStack {
            switch item {
            case .text(let text):
                Image(systemName: "character.cursor.ibeam")
                TextEditor( text: Binding(
                    get: { text },
                    set: { newText in
                        item = .text(newText)
                    }
                ))
            case .photo(let photoData, let caption):
                Image(systemName: "photo")
                VStack {
                    if let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onTapGesture {
                                selectedImage = IdentifiableImage(image: uiImage)
                            }
                        Text(caption)
                    } else {
                        Text("Failed to load image")
                    }
                }
            case .url(let url):
                URLImageField(url: Binding(
                    get: { url },
                    set: { newURL in
                        item = .url(newURL)
                    }
                ))
            }
        }
    }
}

// Assuming ListItem and IdentifiableImage are defined as follows:




// Preview

