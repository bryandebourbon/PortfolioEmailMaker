

import SwiftUI

enum ListItem: Codable {
    case text(String)
    case photo(Data, String)
    case url(String)
    
    
    private enum CodingKeys: String, CodingKey {
        case type, text, photo, caption, url
    }
    
    private enum ListItemType: String, Codable {
        case text
        case photo
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ListItemType.self, forKey: .type)
        
        switch type {
        case .text:
            let text = try container.decode(String.self, forKey: .text)
            self = .text(text)
        case .photo:
            let photo = try container.decode(Data.self, forKey: .photo)
            let caption = try container.decode(String.self, forKey: .caption)
            self = .photo(photo, caption)
            
        case .url:
            let url = try container.decode(String.self, forKey: .url)
            self = .url(url)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode(ListItemType.text, forKey: .type)
            try container.encode(text, forKey: .text)
        case .photo(let photo, let caption):
            try container.encode(ListItemType.photo, forKey: .type)
            try container.encode(photo, forKey: .photo)
            try container.encode(caption, forKey: .caption)
        case .url(let url):
            try container.encode(ListItemType.url, forKey: .type)
            try container.encode(url, forKey: .url)
            
        }
    }
}


extension UIImage {
    func toData() -> Data? {
        return self.jpegData(compressionQuality: 1.0)
    }
    
    static func fromData(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
