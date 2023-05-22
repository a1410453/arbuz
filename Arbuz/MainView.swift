import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var model = Model()
    @State var tabSelection = 0
    @State var previousTabSelection = -1 // any invalid value
    
    
    var body: some View {
        TabView (selection: $model.tabViewSelectedIndex){
            CatalogView()
                .tag(0)
                .tabItem {
                    if !model.displayingReservationForm {
                        Label("Catalog", systemImage: "menucard.fill")
                    }
                }
                .onAppear() {
                    tabSelection = 0
                }
//                .environmentObject(viewContext)

            
            LocationsView()
                .tag(1)
                .tabItem {
                    if !model.displayingReservationForm {
                        Label("Basket", systemImage: "basket.fill")
                    }
                }
                .onAppear() {
                    tabSelection = 1
                }
            
            
            SubcriptionView()
                .tag(2)
                .tabItem {
                    if !model.displayingReservationForm {
                        Label("Subcription", systemImage: "calendar.badge.clock")
                    }
                }
                .onAppear() {
                    tabSelection = 2
                }
        }
        .id(tabSelection)
        .environmentObject(model)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(Model())
    }
}




