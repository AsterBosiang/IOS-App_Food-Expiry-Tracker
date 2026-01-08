import SwiftUI

struct FoodGridView: View {
    @ObservedObject var dataManager: FoodDataManager
    @State private var selectedItem: FoodItem?
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(dataManager.nonExpiredItems()) { item in
                    FoodItemCard(item: item)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
            .padding(10)
        }
        .sheet(item: $selectedItem) { item in
            EditFoodView(dataManager: dataManager, item: item)
        }
    }
}

struct FoodItemCard: View {
    let item: FoodItem
    
    var body: some View {
        VStack(alignment: .center) {
            Text(item.name)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(daysUntilExpiry(item.expiryDate))
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let quantity = item.quantity {
                Text("Qty: \(quantity)")
                    .font(.caption)
            }
        }
        .padding()
        .frame(height: 100)
        .background(cardColor)
        .cornerRadius(10)
    }
    
    var cardColor: Color {
        let days = daysBetween(Date(), item.expiryDate)
        
        if days < 3 {
            return Color.green.opacity(0.3)
        } else if days < 7 {
            return Color.green.opacity(0.5)
        } else {
            return Color.green.opacity(0.7)
        }
    }
    
    func daysUntilExpiry(_ date: Date) -> String {
        let days = daysBetween(Date(), date)
        return days == 1 ? "1 day left" : "\(days) days left"
    }
    
    func daysBetween(_ start: Date, _ end: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start, to: end)
        return max(components.day ?? 0, 0)
    }
}
