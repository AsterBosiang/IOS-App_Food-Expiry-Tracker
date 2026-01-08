import SwiftUI

struct AllFoodListView: View {
    @ObservedObject var dataManager: FoodDataManager
    @Binding var isPresented: Bool
    @State private var selectedItem: FoodItem?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.nonExpiredItems()) { item in
                    FoodItemRow(item: item)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
            .navigationTitle("All Food Items")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
        .sheet(item: $selectedItem) { item in
            EditFoodView(dataManager: dataManager, item: item)
        }
    }
}

struct FoodItemRow: View {
    let item: FoodItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                
                Text("Expiry: \(formattedDate(item.expiryDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let quantity = item.quantity {
                Text("Qty: \(quantity)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
