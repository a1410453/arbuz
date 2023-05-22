//
// DisplayItem.swift



import SwiftUI


struct DisplayItem: View {
    @ObservedObject private var item:Item
    @State var showAlert = false
    @State var count = 1
    init(_ item:Item) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            HStack{
                Text(item.name ?? "")
                    .padding([.top, .bottom], 7)
                
                Spacer()
                
                Text(item.inStock ?? "")
                
                Spacer()
                
                Text(item.formatPrice())
                    .monospaced()
                    .font(.callout)
            }
            
            HStack{
                Stepper(value: $count, step: 1) {
                    Text("Qty: \(count)")
                        .monospaced()
                        .font(.callout)
                        .foregroundColor(.red)
                    
                }.foregroundColor(.red)
                Spacer()
                //Button(item.?"Add to basket":"Out os stock")
                Button("Add to basket") {
                    item.quantity = Float(count)
                    showAlert = addToBasket(item)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.green)
                .alert("Order placed, thanks!",
                    isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }

            }
            .contentShape(Rectangle())
            
        }

    }
}

 
private func addToBasket(_ item: Item)-> Bool{
    // && item.inStock - item.quantity > 0 && Basket.basket.contains(item)
    if Int(item.inStock!)! - Int(item.quantity) >= 0{
        Basket.basket.append(item)
        return true
    }
    return false
}
