import SwiftUI
import Charts

struct AnalysisView: View {
    @ObservedObject var dataManager: FoodDataManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Analysis")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.top, 5)
            
            ChartView(data: dataManager.consumptionAnalysisData())
        }
    }
}

struct ChartView: View {
    let data: [(String, Int)]
    
    var body: some View {
        Chart {
            ForEach(data, id: \.0) { item in
                LineMark(
                    x: .value("Month", item.0),
                    y: .value("Consumed", item.1)
                )
                .foregroundStyle(Color.white)
                
                PointMark(
                    x: .value("Month", item.0),
                    y: .value("Consumed", item.1)
                )
                .foregroundStyle(Color.white)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
    }
}
