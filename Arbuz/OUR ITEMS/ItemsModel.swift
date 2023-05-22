import Foundation
import CoreData


@MainActor
class ItemsModel: ObservableObject {
    
    @Published var menuItems = [CatalogItem]()
        
    
    func reload(_ coreDataContext:NSManagedObjectContext) async {
        let url = URL(string: "https://mocki.io/v1/09d492bb-5061-43fa-9180-c70c9236676f")!
        /*https://mocki.io/v1/c10c0a81-7b63-4b81-9113-d9da2568f6f6*/
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

