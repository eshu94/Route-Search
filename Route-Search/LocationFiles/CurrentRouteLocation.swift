//
//  CurrentRouteLocation.swift
//  Route-Search
//
//  Created by ESHITA on 20/05/21.
//

import Foundation
import MapKit

class CurrentRouteLocation: ObservableObject {
    @Published var searchedLatitude: Double
    @Published var searchedLongitude: Double
    
    init() {
        self.searchedLatitude = 0.0
        self.searchedLongitude = 0.0
    }
    
    func updateSearchedLoc(searchedLatitude: Double,searchedLongitude: Double ) {
        self.searchedLatitude = searchedLatitude
        self.searchedLongitude = searchedLongitude
    }
}
