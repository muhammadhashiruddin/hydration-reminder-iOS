//
//  SingleListItemUI.swift
//  Hydration Reminder
//
//  Created by Muhammad Hashir Uddin on 08/09/2021.
//

import SwiftUI

struct SingleListItemUI: View {
    var modeldata : ModelData
    
    var body: some View {
        let drinkName : [String] = ["Juice","Tea","Water","Coffee","Other"]
        let imageArray : [Color] = [.orange,Color(red: 0.6, green: 0.4, blue: 0.2),.blue,Color(red: 0.3, green: 0.26, blue: 0.03),.gray]
        
        HStack {
            Image(systemName: "drop.fill")
                .resizable()
                .frame(width: 30, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(imageArray[drinkName.firstIndex(of: modeldata.drinkType) ?? 2])
            
            VStack {
                Text(modeldata.drinkType)
                    .foregroundColor(imageArray[drinkName.firstIndex(of: modeldata.drinkType) ?? 2])
                Text(String(modeldata.drinkQuantity)+" ml")
            }.font(.title3)
            .padding(.leading, 10)
            
            Spacer()
            
            Text(tinmeString(time:modeldata.time))
                .font(.title3)
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    func tinmeString(time: Double)->String{
        
        let now = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm"

        return formatter.string(from: now)
    }
}

struct SingleListItemUI_Previews: PreviewProvider {
    static var previews: some View {
        SingleListItemUI(modeldata: ModelData(drinkType: "Water", drinkQuantity: 200, time: 10000000))
    }
}
