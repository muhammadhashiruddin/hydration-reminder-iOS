//
//  Hydration_ReminderApp.swift
//  Hydration Reminder
//
//  Created by Muhammadashir Uddin on 04/09/2021.
//

import SwiftUI

@main
struct Hydration_ReminderApp: App {
    @StateObject private var modelData = ModelDataClass()
    
    var body: some Scene {
        WindowGroup {
            ContentView( drinkCircle: modelData.addQuantity(), healthStore: HealthStoreData())
                .environmentObject(modelData)
                .environmentObject(DatapointClass())
                .environmentObject(Settings())
        }
    }
}
