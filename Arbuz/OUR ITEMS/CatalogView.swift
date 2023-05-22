import SwiftUI
import CoreData

struct CatalogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var itemsModel = ItemsModel()
    
    @State var searchText = ""
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            // If searchText is empty, return a predicate that matches all entries
            return NSPredicate(value: true)
        } else {
            // If searchText is not empty, return a predicate that matches entries containing searchText in their name (case-insensitive and diacritic-insensitive)
            return NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        return [sortDescriptor]
    }
    
    var body: some View {
        VStack {
            ArbuzLogo()
                .padding(.bottom, 10)
                .padding(.top, 50)
            
            Text ("Tap to order")
                .foregroundColor(.black)
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 8)
                .background(Color("approvedYellow"))
                .cornerRadius(20)
            
            NavigationView {
                   FetchedObjects(
                       predicate:buildPredicate(),
                       sortDescriptors: buildSortDescriptors()) {
                           (items: [Item]) in
                           List {
                               ForEach(items, id:\.self) { item in
                                   DisplayItem(item)
                               }
                           }
                           .searchable(text: $searchText,
                                       prompt: "search...")
                       }
               }
            
            // SwiftUI has this space between the title and the list
            // that is amost impossible to remove without incurring
            // into complex steps that run out of the scope of this
            // course, so, this is a hack, to bring the list up
            // try to comment this line and see what happens.
            .padding(.top, -10)//
            

            
            // makes the list background invisible, default is gray
                   .scrollContentBackground(.hidden)
            
            // runs when the view appears
                   .task{
                       await itemsModel.reload(viewContext)
                   }
        }
    }
        

    
}





