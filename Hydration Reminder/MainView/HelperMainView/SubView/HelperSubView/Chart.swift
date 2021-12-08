//
//  Chart.swift
//  Hydration Reminder
//
//  Created by Muhammad Hashir Uddin on 11/09/2021.
//

import SwiftUI
import SwiftUICharts

struct Chartt: View {
    @EnvironmentObject var datapointClass : DatapointClass
    @Binding var drinkDataHK: [DrinkDataFromHK]
    
    let colors: [Color] = [Color.blue, Color.pink, Color.green, Color.orange, Color.purple, Color.yellow, Color.red]
    
    var body: some View {
        VStack{
            if drinkDataHK.count < 1{
                Text("No Data")
            }else{
                Section(header: Text("7 days Record")) {
                    BarChartView(dataPoints: datapointClass.data)
                        .padding()
                }
            }
        }
        .onAppear(){
            var count = 0
            datapointClass.data.removeAll()
            
            for data in drinkDataHK{
                let day = Legend(color: colors[count], label: LocalizedStringKey(timeString(now: data.date)))
                datapointClass.data.append(.init(value: Double(data.quantity), label: "Day \(count + 1)", legend: day))
                count = count + 1
            }
            
        }
    }
    
    func timeString(now: Date)->String{
        
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return formatter1.string(from: now)
        
    }
}

struct Chart_Previews: PreviewProvider {
    static var previews: some View {
        Chartt(drinkDataHK: .constant([]))
            .environmentObject(DatapointClass())
    }
}
