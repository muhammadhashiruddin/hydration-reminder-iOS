
import SwiftUI
import UserNotifications

struct ContentView: View {
    @State var selectedDrink : String = "Water"
    @State var drinkQuantity = 200
    
    
    @State var drinkCircle:Int
    
    @State var backUp : Bool = false
    @EnvironmentObject var modelDataClass: ModelDataClass
    @EnvironmentObject var settings: Settings
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showingSheet = false
    
    var healthStore:HealthStoreData
    
    var body: some View {
        NavigationView {
            VStack {
                    Button(action: {
                        let date = NSDate().timeIntervalSince1970
                        
                        drinkCircle = drinkCircle + drinkQuantity
                        modelDataClass.addItem(drinkType: selectedDrink, drinkQuantity: drinkQuantity, time: date)
                        
                        notif()
                        
                        if backUp{
                            healthStore.storeData(drinkQuantity: drinkQuantity, start: Date(timeIntervalSince1970: date))
                        }
                    }, label: {
                        CircleProgress(drinkCircle: drinkCircle, percentage:                          (CGFloat(drinkCircle)/CGFloat(settings.totalGoal)) * CGFloat(100))
                            .frame(width: 260, height: 260, alignment: .center)
                        
                    }).buttonStyle(PlainButtonStyle())
                        .frame(alignment: .center)
                    List{
                        Drinking_Calculation(selectedDrink: $selectedDrink, drinkQuantity: $drinkQuantity)
                        
                        ForEach(modelDataClass.modelData,id: \.self) { data in
                            SingleListItemUI(modeldata: data)
                        }
                        .onDelete(perform: delete)
                    }
                Spacer()
                
                HStack{
                    
                    Button(action: {
                        showingSheet.toggle()
                    }, label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width : 30 , height : 30 , alignment: .leading)
                            .padding(.leading)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }).sheet(isPresented: $showingSheet) {
                        InfoSheet()
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: DetailView(drinkCircle: $drinkCircle,  healthStore: HealthStoreData())) {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .frame(width : 30 , height : 30 , alignment: .leading)
                            .padding(.trailing)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                }.frame(height:40)
                    .background(colorScheme == .dark ? Color.black : Color.white)
            }.navigationBarHidden(true)
        }.navigationBarHidden(true)
            .onAppear(){
                healthStore.requestAuthorization{ success in
                    if success{
                        backUp = true
                    }
                }
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
    }
    
    func delete(at offsets: IndexSet) {
        let modelData = modelDataClass.modelData[offsets.first ?? 0]
        drinkCircle = drinkCircle - modelData.drinkQuantity
        if backUp{
            healthStore.deleteData(startDate: Date(timeIntervalSince1970: modelData.time))
        }
        modelDataClass.removeItem(at: offsets)
    }
    
    func notif(){
        let content = UNMutableNotificationContent()
        content.title = "Drink Water"
        content.subtitle = "Time to get hydrated"
        content.sound = UNNotificationSound.default
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(settings.notifTime) * 60.0 , repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: "key", content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(drinkCircle: 600,healthStore: HealthStoreData())
            .preferredColorScheme(.dark)
            .environmentObject(ModelDataClass())
            .environmentObject(Settings())
    }
}
