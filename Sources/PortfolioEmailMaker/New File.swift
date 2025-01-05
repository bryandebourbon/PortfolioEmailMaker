import Foundation

class PersistenceManager {
    private let itemsKey = "items"
    
    func saveItems(_ items: [ListItem]) {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: itemsKey)
        } catch {
            print("Failed to encode items: \(error)")
        }
    }
    
    func loadItems() -> [ListItem] {
        if let data = UserDefaults.standard.data(forKey: itemsKey) {
            do {
                return try JSONDecoder().decode([ListItem].self, from: data)
            } catch {
                print("Failed to decode items: \(error)")
            }
        }
        return []
    }
    
    func clearItems() {
        UserDefaults.standard.removeObject(forKey: itemsKey)
    }
}
