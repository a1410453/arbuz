import SwiftUI

struct SubcriptionView: View {
    @EnvironmentObject var model:Model
    
    var body: some View {
        // you can create variables inside body
        // to help you reduce code repetition
        let restaurant = model.reservation.restaurant
        
        ScrollView {
            VStack {
                ArbuzLogo()
                    .padding(.bottom, 20)
                
                if restaurant.city.isEmpty {
                    
                    VStack {
                        // if city is empty no reservation has been
                        // selected yet, so, show the following message
                        Text("No subscriptions yet")
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight:.infinity)
                    
                    
                } else {
                    
                    Text("SUBSCRIPTION")
                        .padding([.leading, .trailing], 40)
                        .padding([.top, .bottom], 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                        .padding(.bottom, 20)
                    
                    
                    HStack {
                        VStack (alignment: .leading) {
                            Text("CITY")
                                .font(.subheadline)
                                .padding(.bottom, 5)
                            MarketView(restaurant)
                        }
                        Spacer()
                    }
                    .frame(maxWidth:.infinity)
                    .padding(.bottom, 20)
                    
                    Divider()
                        .padding(.bottom, 20)
                    
                    
                    VStack {
                        HStack {
                            Text("NAME: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.customerName)
                            Spacer()
                        }
                        
                        HStack {
                            Text("E-MAIL: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.customerEmail)
                            Spacer()
                        }
                        
                        HStack {
                            Text("PHONE: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.customerPhoneNumber)
                            Spacer()
                        }
                        
                        HStack {
                            Text("ADDRESS: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.customerAddress)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 20)
                    
                    
                    
                    VStack {
                        HStack {
                            Text("ORDER DATE: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.reservationDate, style: .date)
                            Spacer()
                        }
                        
                        HStack {
                            Text("ORDER TIME: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.reservationDate, style: .time)
                            Spacer()
                        }
                        HStack {
                            Text("SUBSCRIBED UNTIL: ")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(model.reservation.untilDate, style: .date)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 20)
                    
                    HStack{
                        Text("DELIVERY TIME: ")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Text("\(Basket.deliveryTime):00 - \(Basket.deliveryTime+2):00 ")
                            .frame(width: 120, height: 20)
                            .fontWeight(.semibold)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color(.green))
                            }
                        
                        
                        
                    }
                    .padding(.bottom, 20)
                    
                    
                    VStack(alignment: .leading, spacing: 6){
                        Text("DELIVERY FREQUENCY:")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        let weekDays = Calendar.current.weekdaySymbols
                        HStack(spacing: 10){
                            ForEach(weekDays, id: \.self){ day in
                                let index = Basket.weekDays.firstIndex { value in
                                    return value == day
                                } ?? -1
                                Text(day.prefix(2))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical,12)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(index != -1 ? Color(.green) : Color(.red).opacity(0.4))
                                    }
                            }
                        }
                        .padding(.top,15)
                        
                        Divider()
                            .padding(.vertical,10)
                        
                        
                    }
            
                    HStack {
                        VStack (alignment: .leading) {
                            Text("ORDERED ITEMS:")
                                .font(.subheadline)
                            ForEach(Basket.basket, id:\.self) { item in
                                HStack{
                                    Text(convertItemCount(item.quantity))
                                    Text(item.name!)
                                }
                               
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth:.infinity)
                }
            }
        }
        .padding(50)
    }
}

func convertItemCount(_ itemCount: Float)->String{
    return "x" + String(itemCount)
}
