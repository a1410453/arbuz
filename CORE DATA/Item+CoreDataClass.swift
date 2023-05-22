import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    func formatPrice() -> String {
        let spacing = price < 10 ? " " : ""
        return "₸ " + spacing + String(format: "%.2f", price)
    }
    
}
