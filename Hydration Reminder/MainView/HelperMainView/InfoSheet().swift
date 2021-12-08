//
//  InfoSheet().swift
//  Hydration Reminder
//
//  Created by Muhammad Hashir Uddin on 15/09/2021.
//

import SwiftUI

struct InfoSheet: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                Text("Hydration is more than just drinking water to quench thirst. Hydration plays a crucial role in many different body function. Proper hydration allows our bodies to regulate body temperature. It also keeps joints lubricated and helps deliver nutrients to cells. Drinking adequate water helps us sleep better, improves mood, fight infections, and can improve cognition.")
                Text("When a person consumes an excessive amount of water and cells in their brain start to swell, the pressure inside their skull increases. This causes the first symptoms of water intoxication, which include:")
                Text("headaches")
                Text("nausea")
                Text("vomiting")
                Text("It’s also important to remember that water needs vary with age, sex, weather, activity level, and overall health. So there is no exact formula on how much to drink. Common situations such as extreme heat, significant activity, and illness with fever will all require more fluid intake than average.")
            }
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Press to dismiss")
                    .font(.title)
            })
            
        }.padding()
        .opacity(0.6)
        .navigationBarTitle("Information")
    }
}

struct InfoSheet_Previews: PreviewProvider {
    static var previews: some View {
        InfoSheet()
    }
}
