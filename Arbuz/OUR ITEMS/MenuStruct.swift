import Foundation

struct JSONCatalog: Codable {
    let menu: [CatalogItem]
}


struct CatalogItem: Codable, Identifiable {
    let id: Int
    let title: String
    let price: String
    let size: String
    let inStock: String
    
}
