import SwiftUI

struct ToolbarView: View {
    @Binding var isDeleteMode: Bool
    @Binding var showingTextSheet: Bool
    @Binding var showingImagePicker: Bool
    @Binding var isShowingMailView: Bool
    var clearUserDefaults: () -> Void
    
    var body: some View {
        HStack {
            Button(action: { isDeleteMode.toggle() }) {
                Text(isDeleteMode ? "Done" : "Edit")
            }
            Button(action: { showingTextSheet = true }) {
                Image(systemName: "text.badge.plus")
            }
            Button(action: { showingImagePicker = true }) {
                Image(systemName: "photo.on.rectangle.angled")
            }
            Button(action: { isShowingMailView.toggle() }) {
                Image(systemName: "paperplane.fill")
            }
            Button(action: { clearUserDefaults() }) {
                Image(systemName: "trash")
            }
        }
    }
}
