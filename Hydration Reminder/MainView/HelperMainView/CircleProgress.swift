//
//  CircleProgress.swift
//  Hydration Reminder
//
//  Created by Muhammad Hashir Uddin on 04/09/2021.
//

import SwiftUI

struct CircleProgress: View {
    var drinkCircle:Int
    var percentage:CGFloat
    @State private var fullText: String = "0"
    @EnvironmentObject var totalDrinkClass: Settings

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .shadow(color: (percentage > 25)  ? .blue : .red, radius: 10)
                .overlay(Circle()
                            .trim(from: 0.0, to: CGFloat(min(self.percentage * 0.01, 1.0)))
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .fill(AngularGradient(gradient: Gradient(colors: [(percentage > 25)  ? .blue : .red, (percentage > 25)  ? .blue : .red]), center: .center/*@END_MENU_TOKEN@*/, startAngle: /*@START_MENU_TOKEN@*/.zero, endAngle: .init(degrees: 360)))
                            .padding(.leading, 30)
                            .padding(.trailing, 30))
                
                .rotationEffect(.degrees(-90))
                
                .animation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0))
            
            VStack {
                HStack {
                    Text(String(drinkCircle))
                        .foregroundColor((percentage > 25)  ? .blue : .red)
                        .bold()
                        .font(/*@START_MENU_TOKEN@*/.largeTitle)
                    
                    Text("mL")
                        .font(.title)
                }
                
                Text("of")
                    .font(/*@START_MENU_TOKEN@*/.title)
                
                HStack {
                    Text(String(totalDrinkClass.totalGoal))
                        .font(.largeTitle)
                    
                    Text("mL")
                        .font(.title)
                }
                
                
                
                Text(String(format: "%.0f", CGFloat(min(self.percentage, 100.0)))+"%")
                    .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                    .foregroundColor((percentage > 25)  ? .blue : .red)
                    .font(.largeTitle)
            }
            
        }
    }
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
}

struct CircleProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgress(drinkCircle: 200, percentage: 20)
            .environmentObject(Settings())
    }
}
