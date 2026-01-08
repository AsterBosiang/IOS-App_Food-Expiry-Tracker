import Foundation
import SwiftUI

class FoodDataManager: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    
    init() {
        loadData()
    }
    
    func addFood(name: String, expiryDate: Date, quantity: Int?) {
        let newItem = FoodItem(name: name, expiryDate: expiryDate, quantity: quantity)
        foodItems.append(newItem)
        saveData()
    }
    
    func updateFood(item: FoodItem) {
        if let index = foodItems.firstIndex(where: { $0.id == item.id }) {
            foodItems[index] = item
            saveData()
        }
    }
    
    func markAsConsumed(item: FoodItem) {
        if let index = foodItems.firstIndex(where: { $0.id == item.id }) {
            foodItems[index].isConsumed = true
            saveData()
        }
    }
    
    func updateQuantity(item: FoodItem, newQuantity: Int?) {
        if let index = foodItems.firstIndex(where: { $0.id == item.id }) {
            foodItems[index].quantity = newQuantity
            saveData()
        }
    }
    
    private func saveData() {
        if let encodedData = try? JSONEncoder().encode(foodItems) {
            UserDefaults.standard.set(encodedData, forKey: "foodItems")
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "foodItems"),
           let decodedItems = try? JSONDecoder().decode([FoodItem].self, from: data) {
            foodItems = decodedItems
        }
    }
    
    // Helper functions for UI
    func nonExpiredItems() -> [FoodItem] {
        return foodItems.filter { !$0.isExpired && !$0.isConsumed }
            .sorted { $0.expiryDate < $1.expiryDate }
    }
    
    func recentlyExpiredItems() -> [FoodItem] {
        let expiredItems = foodItems.filter { $0.isExpired && !$0.isConsumed }
        return expiredItems.sorted { $0.expiryDate > $1.expiryDate }
    }
    
    func consumptionAnalysisData() -> [(String, Int)] {
        // This returns monthly data for the last 6 months
        var monthlyData: [(String, Int)] = []
        let calendar = Calendar.current
        
        for i in 0..<6 {
            if let date = calendar.date(byAdding: .month, value: -i, to: Date()) {
                let month = calendar.component(.month, from: date)
                let year = calendar.component(.year, from: date)
                
                let itemsConsumedThisMonth = foodItems.filter { item in
                    item.isConsumed &&
                    calendar.component(.month, from: item.createdAt) == month &&
                    calendar.component(.year, from: item.createdAt) == year
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM"
                let monthName = dateFormatter.string(from: date)
                
                monthlyData.append((monthName, itemsConsumedThisMonth.count))
            }
        }
        
        return monthlyData.reversed()
    }
}
