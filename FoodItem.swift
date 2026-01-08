import Foundation

struct FoodItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var expiryDate: Date
    var quantity: Int?
    var isConsumed: Bool = false
    var createdAt: Date = Date()
    
    var isExpired: Bool {
        return Date() > expiryDate
    }
}
