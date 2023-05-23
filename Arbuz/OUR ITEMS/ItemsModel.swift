import Foundation
import CoreData


@MainActor
class ItemsModel: ObservableObject {
    
    @Published var menuItems = [CatalogItem]()
    
    
    func reload(_ coreDataContext:NSManagedObjectContext) async {
        
            let url = URL(string: "https://mocki.io/v1/0044a4a9-61ac-470d-9a88-50f23a4375fc")!
            let urlSession = URLSession.shared
            
            do {
                let (data, _) = try await urlSession.data(from: url)
                let fullMenu = try JSONDecoder().decode(JSONCatalog.self, from: data)
                menuItems = fullMenu.menu
                
                // populate Core Data
                Item.deleteAll(coreDataContext)
                Item.createItemsFrom(menuItems:menuItems, coreDataContext)
            }
            catch { }
        
    }
}



func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}


extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func itemsTask(with url: URL, completionHandler: @escaping (JSONCatalog?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

