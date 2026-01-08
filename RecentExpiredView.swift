import SwiftUI

struct RecentlyExpiredView: View {
    @ObservedObject var dataManager: FoodDataManager
    
    // Define grid columns - matching the grid format in FoodGridView
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Wasted")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.top, 5)
            
            if dataManager.recentlyExpiredItems().isEmpty {
                // This ensures the view maintains the same height even when empty
                Spacer()
                Text("No expired items")
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(dataManager.recentlyExpiredItems()) { item in
                            ExpiredItemCard(item: item)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
    }
}

// This is the missing view that's causing the error
struct ExpiredItemCard: View {
    let item: FoodItem
    @State private var cardColor: Color = Color.red.opacity(0.3) // Default color
    
    var body: some View {
        VStack(alignment: .center) {
            Text(item.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("Expired: \(daysSinceExpiry(item.expiryDate))")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            if let quantity = item.quantity {
                Text("Qty: \(quantity)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(8)
        .frame(height: 80)
        .background(cardColor)
        .cornerRadius(10)
        .onAppear {
            // You can customize the color based on how long it's been expired
            let days = daysBetween(item.expiryDate, Date())
            if days <= 1 {
                cardColor = Color.red.opacity(0.3)
            } else if days <= 3 {
                cardColor = Color.red.opacity(0.5)
            } else {
                cardColor = Color.red.opacity(0.7)
            }
        }
    }
    
    func daysSinceExpiry(_ date: Date) -> String {
        let days = daysBetween(date, Date())
        return days == 1 ? "1 day ago" : "\(days) days ago"
    }
    
    func daysBetween(_ start: Date, _ end: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start, to: end)
        return max(components.day ?? 0, 0)
    }
}
