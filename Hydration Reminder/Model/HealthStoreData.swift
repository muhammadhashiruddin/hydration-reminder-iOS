//
//  HealthStoreData.swift
//  Hydration Reminder
//
//  Created by Muhammad Hashir Uddin on 10/09/2021.
//

import Foundation
import HealthKit

extension Date{
    static func mondayAt12AM()->Date{
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}


class HealthStoreData{
    var healthStore : HKHealthStore?
    var query : HKStatisticsCollectionQuery?
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func calculatingDrinks(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let drink = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        
        let start = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let anchor = Date.mondayAt12AM()
        
        let daily = DateComponents(day:1)
        
        let filter = HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
                
        query = HKStatisticsCollectionQuery(quantityType: drink, quantitySamplePredicate: filter, options: .cumulativeSum, anchorDate: anchor, intervalComponents: daily)
        
        query!.initialResultsHandler = {query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    func requestAuthorization(completion : @escaping (Bool) -> Void) {
        let drinkPermission = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        
        guard let healhStore = self.healthStore else {
            return completion(false)
        }
        
        healhStore.requestAuthorization(toShare: [drinkPermission], read: [drinkPermission]) { (success, error) in
            completion(success)
        }
    }
    
    func storeData(drinkQuantity : Int, start: Date){
        let drink = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!

        let end = start + 1

        let quantity = HKQuantity(unit: HKUnit.liter(), doubleValue: Double(drinkQuantity)/Double(1000))

        let sample = HKQuantitySample(type: drink, quantity: quantity, start: start, end: end)

        healthStore?.save(sample, withCompletion: { success, error in
            if success{
                print("success in storing")
            }
        })
    }
    
    func deleteData(startDate : Date) {
        let drink = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        
        let endDate = startDate + 1
//        let quantity = HKQuantity(unit: HKUnit.liter(), doubleValue: Double(drinkQuantity)/Double(1000))
        
//        let sample = HKQuantitySample(type: drink, quantity: quantity, start: start, end: end)
        
        let filter = HKQuery.predicateForSamples(withStart: startDate , end: endDate, options: .strictStartDate)
        
        healthStore?.deleteObjects(of: drink, predicate: filter, withCompletion: { success, idk, error in
            if success{
                print("success in deleting")
            }
        })
        
        
    }
}
