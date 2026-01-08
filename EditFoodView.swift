import SwiftUI

struct EditFoodView: View {
    @ObservedObject var dataManager: FoodDataManager
    @Environment(\.presentationMode) var presentationMode
    let item: FoodItem
    
    @State private var quantity: String
    
    init(dataManager: FoodDataManager, item: FoodItem) {
        self.dataManager = dataManager
        self.item = item
        self._quantity = State(initialValue: item.quantity != nil ? "\(item.quantity!)" : "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details")) {
                    Text("Food: \(item.name)")
                    
                    Text("Expiry: \(formattedDate(item.expiryDate))")
                    
                    TextField("Quantity", text: $quantity)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button("Mark as Consumed") {
                        dataManager.markAsConsumed(item: item)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.green)
                }
            }
            .navigationTitle("Edit Food Item")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    updateQuantity()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func updateQuantity() {
        let newQuantity = Int(quantity)
        dataManager.updateQuantity(item: item, newQuantity: newQuantity)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
