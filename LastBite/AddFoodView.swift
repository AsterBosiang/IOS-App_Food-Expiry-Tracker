import SwiftUI

struct AddFoodView: View {
    @ObservedObject var dataManager: FoodDataManager
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var expiryDate = Date()
    @State private var quantityString: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details")) {
                    TextField("Food Name", text: $name)
                    
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                    
                    TextField("Quantity (Optional)", text: $quantityString)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Food Item")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    saveFood()
                    isPresented = false
                }
                .disabled(name.isEmpty)
            )
        }
    }
    
    private func saveFood() {
        let quantity = Int(quantityString)
        dataManager.addFood(name: name, expiryDate: expiryDate, quantity: quantity)
    }
}
