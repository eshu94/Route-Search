//
//  RouteListView.swift
//  Route-Search
//
//  Created by ESHITA on 19/05/21.
//

import SwiftUI
import MapKit

struct RouteListView: View {
 
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Routes.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Routes.dateAdded, ascending: false)]) var routes: FetchedResults<Routes>
    @State private var searchedLatitude: Double = 0.0
    @State private var searchedLongitude: Double = 0.0
    @State var locDidUpdated: Bool = false
    @State var uniqueRoute: Int = 0
    @State var logoutDidSucceed: Bool = false
    @State var savedRoutesView:Bool = false
    @ObservedObject var currentRouteLoc = CurrentRouteLocation()
    
    @ObservedObject var locationService:LocationService = LocationService()
    
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)

        }
    var body: some View {
        
        NavigationView {
            VStack(alignment:.leading) {
                Form {
                    Section(header: Text("Location Search")
                                .font(.custom("Times New Roman",size:18))
                                .fontWeight(.semibold)
                                .textCase(.none)) {
                        ZStack(alignment: .trailing) {
                            TextField("Search", text: $locationService.queryFragment)
                                .modifier(ClearButton(text: $locationService.queryFragment, clearRoute:$locDidUpdated ))
                                .foregroundColor(.black)
                        }
                    }
                    Section(header: Text("Results")
                                .font(.custom("Times New Roman",size:18))
                                .fontWeight(.semibold)
                                .textCase(.none)) {
                        List {
                            ForEach(locationService.searchResults, id: \.self) { completionResult in
                                Button(action: {
                                    print(completionResult.title)
                                    self.locDidUpdated = false
                                    LocationManager().getCoordinateFrom(address: completionResult.title) {  coordinate, error in
                                        guard let coordinate = coordinate, error == nil else { return }
                                            print( "Location:\(coordinate)")
                                        self.searchedLatitude = coordinate.latitude
                                        self.searchedLongitude = coordinate.longitude
                                        currentRouteLoc.updateSearchedLoc(searchedLatitude: self.searchedLatitude, searchedLongitude: self.searchedLongitude)
                                        self.locDidUpdated = true
                                        //self.locDeafult = false
                                        
                                        if(routes.isEmpty){
                                            print("1st Obj")
                                            saveRoutes(routeTitle: completionResult.title)
                                        }else{
                                            var alreadySavedRoutes: [String] = []
                                            for routeItem in routes {
                                                print(routeItem.routeTitle as Any)
                                                if let routeTitle = routeItem.routeTitle{
                                                    alreadySavedRoutes.append(routeTitle)
                                                }
                                            }
                                            
                                            if alreadySavedRoutes.contains(completionResult.title) {
                                                print("Route already exists!!!")
                                            }else {
                                                print("Unique entry saved!!")
                                                saveRoutes(routeTitle: completionResult.title)
                                                print("routesCount;\(routes.count)")
                                            }
                                         
                                        }
                                    }
                                }) {
                                  Text(completionResult.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(10)
                                }
                            }
                            
                        }
                    }

                }.foregroundColor(Color(red: 0.2314, green: 0.3765, blue: 0))
                .font(.custom("Times New Roman",size:15))
                if locDidUpdated{
                    MapRouteView().environmentObject(currentRouteLoc)
                }else {
                    MapView()
                }
            }
            .navigationBarTitle("Routes", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action:{
                            self.logoutDidSucceed = true
                            UserDefaults.standard.set(false, forKey: "loginActive")
                            print("logout tapped!!!")
                        }) {
                            Text("Logout")
                        }.background(
                            NavigationLink(destination: LoginView().navigationBarHidden(true)
                                           , isActive: $logoutDidSucceed) {})
                                        }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action:{
                            print("saved tapped!!!")
                            self.savedRoutesView = true
                        }) {
                            Text("Saved")
                        }.background(NavigationLink(destination: SavedRoutesView(),
                                                    isActive: $savedRoutesView){})
                    }
                }
        }
       
        
    }
    
    func saveRoutes(routeTitle: String) {
        let newRoute = Routes(context: managedObjectContext)
        let date = Date()
        newRoute.routeTitle = routeTitle
        newRoute.searchedLatitude = self.searchedLatitude
        newRoute.searchedLongitude = self.searchedLongitude
        newRoute.dateAdded = date
      saveContext()
    }


    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

struct ClearButton: ViewModifier
{
    @Binding var text: String
    @Binding var clearRoute:Bool

    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content

            if !text.isEmpty
            {
                Button(action:
                {
                    self.text = ""
                    self.clearRoute = false
                })
                {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}
struct RouteListView_Previews: PreviewProvider {
    static var previews: some View {
        RouteListView()
    }
}
