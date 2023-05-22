import Foundation
import CoreData


extension Item {
    
    static func createItemsFrom(menuItems:[CatalogItem],
                                 _ context:NSManagedObjectContext) {
        
        for menuItem in menuItems {
            guard let _ = exists(name: menuItem.title, context) else {
                continue
            }
            let oneItem = Item(context: context)
            oneItem.name = menuItem.title
            if let price = Float(menuItem.price) {
                oneItem.price = price
            }
            if  menuItem.size != "" {
                oneItem.size = menuItem.size
            }
            if  menuItem.inStock != "" {
                oneItem.inStock = menuItem.inStock
            }
        }
        
    }
    
    
    private static
    func request() -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult> =
        NSFetchRequest(entityName: String(describing: Self.self))
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = true
        return request
    }
}
