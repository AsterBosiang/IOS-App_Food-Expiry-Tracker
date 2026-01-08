import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = FoodDataManager()
    @State private var showingAddFood = false
    @State private var showingAllFood = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                // Analysis section (green)
                AnalysisView(dataManager: dataManager)
                    .frame(height: 150)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                // Recently wasted section (orange) - now matching Analysis dimensions
                RecentlyExpiredView(dataManager: dataManager)
                    .frame(height: 150) // Same height as Analysis
                    .background(Color.orange.opacity(0.4))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                // Unexpired food items section
                Text("Finished yet?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                FoodGridView(dataManager: dataManager)
                    .background(Color.brown.opacity(0.6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Spacer()
            }
            .padding(.bottom, 60) // Make space for the bottom bar
            
            // Bottom Navigation Bar
            VStack {
                Spacer()
                BottomNavBar(
                    showAllFood: { showingAllFood = true },
                    showAddFood: { showingAddFood = true }
                )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showingAddFood) {
            AddFoodView(dataManager: dataManager, isPresented: $showingAddFood)
        }
        .sheet(isPresented: $showingAllFood) {
            AllFoodListView(dataManager: dataManager, isPresented: $showingAllFood)
        }
    }
}

struct BottomNavBar: View {
    var showAllFood: () -> Void
    var showAddFood: () -> Void
    
    var body: some View {
        HStack {
            Button(action: showAllFood) {
                // Use your custom image here
                // If you want to use a system image temporarily:
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                // Replace with your custom image like this:
                // Image("your-custom-image-name")
                //    .resizable()
                //    .scaledToFit()
                //    .frame(width: 30, height: 30)
            }
            .padding(.leading, 25)
            
            Spacer()
            
            // This is where your add button goes - in the middle bottom
            Button(action: showAddFood) {
                // Replace with your custom image:
                Image("AddButtonImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 80)
                    .offset(y: -20)
            }
            
            Spacer()
            
            // You can add a third button here if needed
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .padding(.trailing, 25)
        }
        .frame(height: 80)
        .background(Color.brown)
        .edgesIgnoringSafeArea(.bottom)
    }
}
#Preview {
    ContentView()
}
