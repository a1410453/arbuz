import Foundation
import UserNotifications

class Model:ObservableObject {
    let restaurants = [
        MarketLocation(city: "Astana",
                       neighborhood: "",
                       phoneNumber: "+7 (705) 926 00 01"),
        MarketLocation(city: "Almaty",
                       neighborhood: "",
                       phoneNumber: "+7 (705) 926 00 00")
    ]
    
    @Published var reservation = Reservation()
    @Published var displayingReservationForm = false
    @Published var temporaryReservation = Reservation()
    @Published var followNavitationLink = false
    
    @Published var displayTabBar = true
    @Published var tabBarChanged = false
    
    
    //MARK: Notification Access Status
    @Published var notificationAccess: Bool = false
    
    
    @Published var tabViewSelectedIndex = Int.max {
        didSet {
            tabBarChanged = true
        }
    }
    
    init(){
        requestNotificationAccess()
    }
    
    func requestNotificationAccess(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { status, _ in
            DispatchQueue.main.async {
                self.notificationAccess = status
            }
        }
    }
}
