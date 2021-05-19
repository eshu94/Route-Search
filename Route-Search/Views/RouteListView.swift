//
//  RouteListView.swift
//  Route-Search
//
//  Created by ESHITA on 19/05/21.
//

import SwiftUI

struct RouteListView: View {
    
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
            
            }
            .navigationBarTitle("Routes", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action:{
                            UserDefaults.standard.set(false, forKey: "loginActive")
                            print("logout tapped!!!")
                        }) {
                            Text("Logout")
                        }
                                        }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action:{}) {
                            Text("Saved")
                                
                        }
                    }
                }
        }
       
        
    }
}

struct RouteListView_Previews: PreviewProvider {
    static var previews: some View {
        RouteListView()
    }
}
