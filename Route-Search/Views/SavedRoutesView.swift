//
//  SavedRoutesView.swift
//  Route-Search
//
//  Created by ESHITA on 21/05/21.
//

import SwiftUI

struct SavedRoutesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Routes.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Routes.dateAdded, ascending: false)]) var routes: FetchedResults<Routes>
    @State var mapViewShow:Bool = false
    @State var tap = false
    var savedRouteDetail = CurrentRouteLocation()
    var body: some View {
        VStack(alignment:.leading){
            List{
                ForEach(routes, id: \.dateAdded){ route in
                    Button(action:{
                        self.mapViewShow = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                            print("route tapped!!!")
                            self.mapViewShow = true
                            self.savedRouteDetail.updateSearchedLoc(searchedLatitude: route.searchedLatitude, searchedLongitude: route.searchedLongitude)
                        }
                    }) {
                        route.routeTitle.map(Text.init)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(10)
                    }
                    
                }
            }
            if mapViewShow {
                MapRouteView().environmentObject(savedRouteDetail)
            }
            
        }
        
        
}
}


struct SavedRoutesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedRoutesView()
    }
}
