import SwiftUI

struct BasketView: View {
    
    @EnvironmentObject var model:Model
    @State var showFormInvalidMessage = false
    @State var errorMessage = ""
    
    
    private var restaurant:MarketLocation
    @State var reservationDate = Date()
    @State var untilDate = Date()
    @State var customerAddress = ""
    @State var specialRequests:String = ""
    @State var customerName = ""
    @State var customerPhoneNumber = ""
    @State var customerEmail = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var temporaryReservation = Reservation()
    
    @State var mustChangeReservation = false
    @State var refreshFlag = ""
    
    init(_ restaurant:MarketLocation) {
        self.restaurant = restaurant
    }
    
    func countTotal() -> String {
        var sum = 0.0
        for i in Basket.basket{
            sum += Double(i.price)*Double(i.quantity)
        }
        return String(sum)
    }
    let date = Date()
    
    var body: some View {
        VStack {
            Form {
                // Restaurant information
                MarketView(restaurant)
                
                // shows the party information
                HStack {
                    Text("ORDER DATE:")
                        .font(.subheadline)
                    Text(date.formatted(.dateTime.day().month().year().hour().minute()))
                }
                .padding([.top, .bottom], 20)
                
                // Textfields showing informations like customer
                // name, phone, email, and special requests
                Group{
                    Group{
                        HStack{
                            Text("NAME: ")
                                .font(.subheadline)
                            TextField("Your name...",
                                      text: $customerName)
                            .disableAutocorrection(true)
                            
                        }
                        
                        HStack{
                            Text("PHONE: ")
                                .font(.subheadline)
                            
                            TextField("Your phone number...",
                                      text: $customerPhoneNumber)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.phonePad)
                        }
                        
                        HStack{
                            Text("E-MAIL: ")
                                .font(.subheadline)
                            TextField("Your e-mail...",
                                      text: $customerEmail)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        }
                        
                        HStack{
                            Text("DELIVERY ADDRESS: ")
                                .font(.subheadline)
                            
                            TextField("Your address...",
                                      text: $customerAddress)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.phonePad)
                        }
                        
                        HStack {
                            VStack (alignment: .leading) {
                                Text("ORDERED ITEMS:"+refreshFlag)
                                    .font(.subheadline)
                                ForEach(Basket.basket, id:\.self) { item in
                                    HStack{
                                        Text(convertItemCount(item.quantity))
                                        Text(item.name!)
                                        Text(item.size!)
                                    }
                                }
                                if !Basket.basket.isEmpty{
                                    Button("empty basket") {
                                        Basket.basket.removeAll()
                                        refreshFlag += " "
                                    }.foregroundColor(.red).underline()
                                    
                                }

                            }
                            Spacer()
                        }
                        .frame(maxWidth:.infinity)
                        
                        HStack{
                            Text("TOTAL: ")
                                .font(.subheadline)
                            Text(countTotal() + " ₸ ")
                        }
                        
                    }
                    
                    
                    HStack{
                        Text("UNTIL DATE: ")
                            .font(.subheadline)
                        DatePicker(selection: $untilDate, in: Date()...,
                                   displayedComponents: [.date]) {
                            //              Text("Select a date")
                        }
                    }
                    
                    
                    // MARK: Frequency selection
                    VStack(alignment: .leading, spacing: 6){
                        Text("Frequency"+refreshFlag).font(.callout.bold())
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
                                    .onTapGesture {
                                        withAnimation {
                                            if index != -1{
                                                Basket.weekDays.remove(at: index)
                                            } else {
                                                Basket.weekDays.append(day)
                                            }
                                            refreshFlag += " "
                                        }
                                    }
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(index != -1 ? Color(.green) : Color(.red).opacity(0.4))
                                    }
                            }
                        }
                        .padding(.top,15)
                        
                        Divider()
                            .padding(.vertical,10)
                        
                        
                        HStack{
                            Text("Delivery Time: " + refreshFlag )
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    ForEach(7...21, id: \.self) { number in
                                        Text("\(number):00 - \(number+2):00 ")
                                            .frame(width: 120, height: 20)
                                            .padding()
                                            .background {
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .fill(number == Basket.deliveryTime ? Color(.green) : Color(.red).opacity(0.4))
                                            }
                                            .onTapGesture {
                                                withAnimation {
                                                    Basket.deliveryTime = number
                                                    refreshFlag += " "
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    
                    // add the RESERVE button
                    Button(action: {
                        validateForm()
                    }, label: {
                        Text("CONFIRM RESERVATION")
                    })
                    .padding(.init(top: 10, leading: 30, bottom: 10, trailing: 30))
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(20)
                    .padding(.top, 10)
                }
            }
            .padding(.top, -40)
            .scrollContentBackground(.hidden)
            .onChange(of: mustChangeReservation) { _ in
                model.reservation = temporaryReservation
            }
            
            // add an alert after this line
            .alert("ERROR", isPresented: $showFormInvalidMessage, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text(self.errorMessage)
            })
        }
        .onAppear {
            model.displayingReservationForm = true
        }
        .onDisappear {
            model.displayingReservationForm = false
        }
    }
    
    private func convertItemCount(_ itemCount: Float)->String{
        return "x" + String(itemCount)
    }
    
    
    private func validateForm() {
        
        // customerName must contain just letters
        let nameIsValid = isValid(name: customerName)
        let emailIsValid = isValid(email: customerEmail)
        
        guard nameIsValid && emailIsValid
        else {
            var invalidNameMessage = ""
            if customerName.isEmpty || !isValid(name: customerName) {
                invalidNameMessage = "Names can only contain letters and must have at least 3 characters\n\n"
            }
            
            var invalidPhoneMessage = ""
            if customerPhoneNumber.isEmpty {
                invalidPhoneMessage = "The phone number cannot be blank.\n\n"
            }
            
            var invalidEmailMessage = ""
            if !customerEmail.isEmpty || !isValid(email: customerEmail) {
                invalidEmailMessage = "The e-mail is invalid or blank.\n\n"
            }
            
            //TODO: address check
            
            var invalidFrequencyMessage = ""
            if Basket.weekDays.isEmpty {
                invalidFrequencyMessage = "The Frequency of deliveries is blank.\n\n"
            }
            
            
            var invalidBasketMessage = ""
            if Basket.basket.isEmpty {
                invalidBasketMessage = "The basket cannot be empty.\n\n"
            }
            
            
            var invalidDeliveryTimeMessage = ""
            if Basket.deliveryTime == 0 {
                invalidDeliveryTimeMessage = "Choose Delivery time.\n\n"
            }
            
            
            self.errorMessage = "Found these errors in the form:\n\n \(invalidNameMessage)\(invalidPhoneMessage)\(invalidEmailMessage)\(invalidFrequencyMessage)\(invalidBasketMessage)\(invalidDeliveryTimeMessage)"
            
            
            
            showFormInvalidMessage.toggle()
            return
        }
        
        // form is valid, proceed
        
        // create new temporary reservation
        let temporaryReservation = Reservation(restaurant:restaurant,
                                               customerName: customerName,
                                               customerEmail: customerEmail,
                                               customerPhoneNumber: customerPhoneNumber,
                                               untilDate:untilDate,
                                               reservationDate:reservationDate,
                                               customerAddress: customerAddress,
                                               specialRequests:specialRequests)
        
        // Store the temporary reservation locally
        self.temporaryReservation = temporaryReservation
        
        // set the flag to defer changing to the model (see .onChange)
        self.mustChangeReservation.toggle()
        
        // dismiss this view
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func isValid(name: String) -> Bool {
        guard !name.isEmpty,
              name.count > 2
        else { return false }
        for chr in name {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == " ") ) {
                return false
            }
        }
        return true
    }
    
    func isValid(email:String) -> Bool {
        guard !email.isEmpty else { return false }
        let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        return emailValidationPredicate.evaluate(with: email)
    }
    
    
}









