//
//  ListItem.swift
//  Hydration Reminder
//
//  Created by Muhammad Hashir Uddin on 07/09/2021.
//

import Foundation
import SwiftUICharts

final class ModelDataClass: ObservableObject {
    @Published var modelData: [ModelData]
    private let key = "SaveData"
    init() {
        if let data = UserDefaults.standard.data(forKey: key){
            if let decoded = try? JSONDecoder().decode([ModelData].self , from: data){
                self.modelData = decoded
                
                let date = Date()
                let calendar = Calendar.current
                let day = calendar.component(.day, from: date)
                
                let time1 = self.modelData.last?.time ?? 0
                let date2 = Date(timeIntervalSince1970: time1)
                let day2 = calendar.component(.day, from: date2)
                
                if day > day2 {
                    self.modelData = []
                    save()
                }
            }else{
                self.modelData = []
            }
        }else{
            self.modelData = []
        }
        
        
    }
    
    private func save(){
        if let decoded = try? JSONEncoder().encode(modelData){
            UserDefaults.standard.set(decoded, forKey: key)
        }
    }
    
    func addItem(drinkType: String, drinkQuantity: Int, time: Double){
        modelData.insert(ModelData(drinkType: drinkType, drinkQuantity: drinkQuantity, time: time), at: 0)
        save()
    }
    
    func removeItem(at offsets: IndexSet) {
        modelData.remove(atOffsets: offsets)
        save()
    }
    
    func addQuantity() -> Int {
        var qty = 0
        for (model) in modelData{
            qty = qty + model.drinkQuantity
        }
        return qty
    }
}

struct ModelData:Hashable,Decodable,Encodable{
    var drinkType: String
    var drinkQuantity: Int
    var time:Double
}

struct DrinkDataFromHK:Identifiable{
    var id = UUID()
    var quantity : Int
    var date : Date
}

final class DatapointClass: ObservableObject{
    @Published var data: [DataPoint] = []
}

final class Settings: ObservableObject{
    @Published var totalGoal: Int
    @Published var notifTime: Int
    private let key2 = "notifkey"
    private let key1 = "goalkey"
    init() {
        if 0 == UserDefaults.standard.integer(forKey: key1){
            totalGoal = 1000
        }else{
            totalGoal = UserDefaults.standard.integer(forKey: key1)
        }
        if 0 == UserDefaults.standard.integer(forKey: key2){
            notifTime = 60
        }else{
            notifTime = UserDefaults.standard.integer(forKey: key2)
        }
    }
}
