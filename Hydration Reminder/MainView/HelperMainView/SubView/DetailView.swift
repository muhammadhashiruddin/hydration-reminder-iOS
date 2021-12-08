//
//  DetailView.swift
//  Hydration Reminder
//
//  Created by Muhammad Hashir Uddin on 10/09/2021.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var modelDataClass : ModelDataClass
    @EnvironmentObject var totalDrinkClass: Settings
    
    @Binding var drinkCircle : Int
    
    @State var backUp : Bool = false
    
    @State var drinkDataHK: [DrinkDataFromHK] = []
    
    var healthStore:HealthStoreData?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            NavigationLink(
                destination: GoalChange(num: totalDrinkClass.totalGoal, goal: true),
                label: {
                    HStack {
                        Text("Goal")
                            .opacity(0.8)
                        Spacer()
                        Text("\(totalDrinkClass.totalGoal) mL")
                            .opacity(0.5)
                        Text(">")
                            .font(.largeTitle)
                            .padding(.leading)
                            .opacity(0.3)
                    }
                }).padding(.trailing)
                .padding(.leading)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .cornerRadius(5.0)
            
            NavigationLink(
                destination: GoalChange(num: Int(totalDrinkClass.notifTime), goal: false),
                label: {
                    HStack {
                        Text("Reminder")
                            .opacity(0.8)
                        Spacer()
                        Text("\(Int(totalDrinkClass.notifTime)) minutes")
                            .opacity(0.5)
                        Text(">")
                            .font(.largeTitle)
                            .padding(.leading)
                            .opacity(0.3)
                    }
                }).padding(.trailing)
                .padding(.leading)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .cornerRadius(5.0)
            
            ScrollView{
                if(drinkDataHK.count > 0){
                    Chartt(drinkDataHK: $drinkDataHK)
                }
            }.padding(.top)
            
        }.navigationBarTitle("Details",displayMode: .inline)
            
            .onAppear(){
                if let healhStore = healthStore{
                    healhStore.requestAuthorization{ success in
                        if success{
                            backUp = true
                            var count = 0
                            drinkDataHK = []
                            
                            healhStore.calculatingDrinks{
                                statisticsCollection in
                                if let statistisCollection = statisticsCollection{
                                    
                                    let start = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
                                    
                                    statistisCollection.enumerateStatistics(from: start, to: Date()) { stats, stop in
                                        
                                        let value = Double(stats.sumQuantity()?.doubleValue(for: .liter()) ?? 0) * Double(1000.0)
                                        
                                        
                                        if count != 0{
                                            drinkDataHK.append(DrinkDataFromHK(quantity: Int(value) , date: stats.startDate))
                                        }
                                        
                                        count = count + 1
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func delete(at offsets: IndexSet) {
        let modelData = modelDataClass.modelData[offsets.first ?? 0]
        drinkCircle = drinkCircle - modelData.drinkQuantity
        if backUp{
            healthStore?.deleteData(startDate: Date(timeIntervalSince1970: modelData.time))
        }
        modelDataClass.removeItem(at: offsets)
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(drinkCircle: .constant(100), healthStore: HealthStoreData())
            .environmentObject(ModelDataClass())
            .environmentObject(DatapointClass())
            .environmentObject(Settings())
        
    }
}
