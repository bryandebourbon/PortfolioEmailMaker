import SwiftUI
import MessageUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var items: [ListItem] = []
    @State private var newItem: NewItem = NewItem()
    @State private var isDeleteMode = false
    @State private var selectedImage: IdentifiableImage?
    @State private var isShowingMailView = false
    @State private var emailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var title = ""
    @State private var showingAddItemOptions = false
    
    private let persistenceManager = PersistenceManager()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    TextField("Enter title", text: $title)
                        .font(.system(size: 36, weight: .bold))
                    
                    ForEach(items.indices, id: \.self) { index in
                        ListItemView(
                            item: $items[index], 
                            selectedImage: $selectedImage
                        )
                        .onDrag { NSItemProvider(object: "\(index)" as NSString) }
                    }
                    .onMove(perform: move)
                    .onInsert(of: [UTType.plainText.identifier], perform: handleOnInsert)
                    .onDelete(perform: deleteItem)
                    
                    Button(action: { showingAddItemOptions = true }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Item")
                        }
                    }
                }
                .toolbar {
                    ToolbarView(
                        isDeleteMode: $isDeleteMode, 
                        showingTextSheet: $newItem.showingTextSheet, 
                        showingImagePicker: $newItem.showingImagePicker, 
                        isShowingMailView: $isShowingMailView, 
                        clearUserDefaults: clearUserDefaults
                    )
                }
                .sheet(isPresented: $newItem.showingImagePicker, onDismiss: addPhoto) {
                    ImagePicker(image: $newItem.image)
                }
                .sheet(isPresented: $isShowingMailView) {
                    MailView(items: $items, result: $emailResult, subject: $title)
                }
                .sheet(item: $selectedImage) { identifiableImage in
                    ImageView(image: identifiableImage.image)
                }
                .actionSheet(isPresented: $showingAddItemOptions) {
                    ActionSheet(
                        title: Text("Add Item"),
                        message: Text("Choose the type of item to add"),
                        buttons: [
                            .default(Text("Text")) {
                                items.append(.text(""))
                                newItem.showingTextSheet = true
                            },
                            .default(Text("Photo")) {
                                newItem.showingImagePicker = true
                            },
                            .default(Text("Link")) {
                                items.append(.url(""))
                            },
                            .cancel()
                        ]
                    )
                }
            }
        }
        .onAppear(perform: loadItems)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        withAnimation {
            items.move(fromOffsets: source, toOffset: destination)
            persistenceManager.saveItems(items)
        }
    }
    
    private func addPhoto() {
        guard let selectedImage = newItem.image else { return }
        if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
            items.append(.photo(imageData, newItem.imageCaption))
            newItem.reset()
            saveItems()
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        persistenceManager.saveItems(items)
    }
    
    private func handleOnInsert(index: Int, items: [NSItemProvider]) {
        if let itemProvider = items.first {
            itemProvider.loadObject(ofClass: NSString.self) { (object, error) in
                if let string = object as? NSString,
                   let originalIndex = Int(string as String) {
                    DispatchQueue.main.async {
                        self.items.move(fromOffsets: IndexSet(integer: originalIndex), toOffset: index)
                        persistenceManager.saveItems(self.items)
                    }
                }
            }
        }
    }
    
    private func saveItems() {
        persistenceManager.saveItems(items)
    }
    
    private func loadItems() {
        items = persistenceManager.loadItems()
    }
    
    private func clearUserDefaults() {
        persistenceManager.clearItems()
        items.removeAll()
    }
}

struct NewItem {
    var text: String = ""
    var url: String = ""
    var image: UIImage?
    var imageCaption: String = ""
    var showingTextSheet: Bool = false
    var showingImagePicker: Bool = false
    
    mutating func reset() {
        text = ""
        url = ""
        image = nil
        imageCaption = ""
        showingTextSheet = false
        showingImagePicker = false
    }
}
