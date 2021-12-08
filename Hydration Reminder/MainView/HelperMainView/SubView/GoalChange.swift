//
//  GoalChange.swift
//  Hydration Reminder
//
//  Created by Muhammad Hashir Uddin on 15/09/2021.
//

import SwiftUI

struct GoalChange: View {
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    @EnvironmentObject var settings: Settings
    @State var num:Int
    var goal: Bool
    var body: some View {
        VStack {
            Text(goal ? "This will be the new goal for you to reach" : "You will be notified by this time")
                .opacity(0.4)
            HStack {
                TextField(goal ? "Enter your new goal" : "Enter remider time", value: $num, formatter: formatter)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(goal ? "mL" : "minutes")
            }.padding()
            if goal{
            if(num > 0) && (num < 10000){
            Button(action: {
                UserDefaults.standard.set(self.num, forKey: "goalkey")
                settings.totalGoal = num
            }, label: {
                Text("Save")
            })
            }
            }else{
                if(num > 0) && (num < 720){
                Button(action: {
                    UserDefaults.standard.set(self.num,forKey: "notifkey")
                    settings.notifTime = num
                }, label: {
                    Text("Save")
                })
            }
            }
        }.navigationBarTitle(goal ? "Drink Goal" : "Reminder")
    }
}

struct GoalChange_Previews: PreviewProvider {
    static var previews: some View {
        GoalChange(num: 1000, goal: true)
            .environmentObject(Settings())

    }
}
