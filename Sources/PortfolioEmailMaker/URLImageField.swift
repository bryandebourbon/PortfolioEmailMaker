import SwiftUI
import WebKit
import Combine

struct URLImageField: View {
    @Binding var url: String
    @State private var imageData: Data? = nil
    @State private var cancellable: AnyCancellable? = nil
    @State private var isGIF: Bool = false
    
    var body: some View {
        VStack {
            if isGIF, let validURL = URL(string: url) {
                WebView(url: validURL)
                  .frame(width: 300, height: 300)
                    .padding()
            } else if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                   // .frame(width: 100, height: 100)
                    .padding()
            } else {
                Text("No image loaded")
                   // .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.2))
                    .padding()
            }
            
            TextField("Enter URL", text: $url)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .padding()
        .onChange(of: url, perform: { newURL in
            fetchImage(from: newURL)
        })
        .onAppear {
            fetchImage(from: url)
        }
    }
    
    private func fetchImage(from urlString: String) {
        guard let validURL = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        // Check if the URL is a GIF
        if validURL.pathExtension.lowercased() == "gif" {
            self.isGIF = true
            self.imageData = nil
            print("Detected GIF: \(validURL)")
            return
        } else {
            self.isGIF = false
        }
        
        cancellable?.cancel()
        cancellable = URLSession.shared.dataTaskPublisher(for: validURL)
            .map { $0.data }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { data in
                if let data = data {
                    print("Fetched image data: \(data.count) bytes")
                } else {
                    print("Failed to fetch image data")
                }
                self.imageData = data
            }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

// Preview for testing purposes

