import SwiftUI

struct MarketView: View {
  private var market:MarketLocation
  
  init(_ market:MarketLocation) {
    self.market = market
  }
  
  var body: some View {
    VStack (alignment: .leading, spacing:3){
      Text(market.city)
        .font(.title2)
      
      HStack {
        Text(market.neighborhood)
        Text(market.phoneNumber)
      }
      .font(.caption)
      .foregroundColor(.gray)

    }
  }
}


