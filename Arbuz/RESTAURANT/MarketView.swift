import SwiftUI

struct MarketView: View {
  private var restaurant:MarketLocation
  
  init(_ restaurant:MarketLocation) {
    self.restaurant = restaurant
  }
  
  var body: some View {
    VStack (alignment: .leading, spacing:3){
      Text(restaurant.city)
        .font(.title2)
      
      HStack {
        Text(restaurant.neighborhood)
        Text("–")
        Text(restaurant.phoneNumber)
      }
      .font(.caption)
      .foregroundColor(.gray)

    }
  }
}


