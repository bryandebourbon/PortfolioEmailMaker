import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Binding var items: [ListItem]
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var subject: String
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                controller.dismiss(animated: true)
            }
            if let error = error {
                parent.result = .failure(error)
            } else {
                parent.result = .success(result)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["recipient@example.com"])
        vc.setSubject(subject)
        
        var bodyText = ""
        
        for item in items {
            switch item {
            case .text(let text):
                bodyText += "<p>\(text)</p>"
            case .photo(let image, let caption):
                // apple email supports actually emailing the image but google expects it from a url via mediaserver/cdn
                let base64String = image.base64EncodedString()
                let imageHTML = """
                    <div><p>\(caption)</p><img src="data:image/jpeg;base64,\(base64String)" alt="Image" width="200"></div>
                    """
                bodyText += imageHTML
            case .url(let url):
                let urlHTML = """
                    <div><img src="\(url)"></a></div>
                    """
                bodyText += urlHTML
            }
        }
        print(bodyText)
        vc.setMessageBody(bodyText, isHTML: true)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
        // No update needed
    }
}

// Example of ListItem2 definition

// Example of ListItem2 definition

