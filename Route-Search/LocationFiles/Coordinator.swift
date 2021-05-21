//
//  Coordinator.swift
//  Route-Search
//
//  Created by ESHITA on 20/05/21.
//

import Foundation
import MapKit

class Coordinator: NSObject, MKMapViewDelegate {
    var control: MapView
    
    init(_ control: MapView) {
        self.control = control
    }
}
