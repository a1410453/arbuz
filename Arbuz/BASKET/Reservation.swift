import Foundation

struct Reservation {
    var restaurant:MarketLocation
    var customerName:String
    var customerEmail:String
    var customerPhoneNumber:String
    var untilDate:Date
    var reservationDate:Date
    var customerAddress:String
    var specialRequests:String

    var id = UUID()
    
    init(restaurant:MarketLocation = MarketLocation(),
         customerName: String = "",
         customerEmail: String = "",
         customerPhoneNumber: String = "",
         untilDate: Date = Date(),
         reservationDate: Date = Date(),
         customerAddress: String = "",
         specialRequests: String = ""
    ) {
        self.restaurant = restaurant
        self.customerName = customerName
        self.customerEmail = customerEmail
        self.customerPhoneNumber = customerPhoneNumber
        self.untilDate = untilDate
        self.reservationDate = reservationDate
        self.customerAddress = customerAddress
        self.specialRequests = specialRequests
    }
    
}

