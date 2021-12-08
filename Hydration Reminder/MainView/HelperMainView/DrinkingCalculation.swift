//
//  Drinking_Calculation.swift
//  Hydration Reminder
//
//  Created by Muhammad Hashir Uddin on 07/09/2021.
//

import SwiftUI

struct Drinking_Calculation: View {
    @Binding var selectedDrink : String
    @Binding var drinkQuantity : Int

    var body: some View {
        let drinkName : [String] = ["Juice","Tea","Water","Coffee","Other"]
        let liters: [Int] = [50,100,150,200,250,300,350,400,450,500]
        let imageArray : [Color] = [.orange,Color(red: 0.6, green: 0.4, blue: 0.2),.blue,Color(red: 0.3, green: 0.26, blue: 0.03),.gray]
        
        VStack {
            Text("Drink:")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.heavy)
            
            Text(selectedDrink)
                .font(.system(size: 30,weight: .heavy))
                .foregroundColor(imageArray[drinkName.firstIndex(of: selectedDrink) ?? 2])
            
            HStack {
                ForEach(imageArray, id: \.self) { imageName in
                    Image(systemName: self.selectedDrink == drinkName[imageArray.firstIndex(of: imageName) ?? 2] ? "drop.fill": "drop")
                        .resizable()
                        .frame(width: 30.0, height: 40.0)
                        .scaledToFit()
                        .foregroundColor(imageName)
                        .gesture(TapGesture().onEnded({ self.selectedDrink = drinkName[imageArray.firstIndex(of: imageName) ?? 2]
                        }))
                }
            }
            
            Text("Quantity:")
                .font(.title)
                .fontWeight(.heavy)
                .padding(.top,20)
            
            Picker("Choose quantity of drink", selection: $drinkQuantity) {
                ForEach(liters, id: \.self) {liter in
                    Text("\(liter) mL")
                }
            }
        }
    }
}

struct Drinking_Calculation_Previews: PreviewProvider {
    static var previews: some View {
        Drinking_Calculation(selectedDrink: .constant("Water"), drinkQuantity: .constant(200))
    }
}
