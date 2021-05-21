//
//  MapView.swift
//  Route-Search
//
//  Created by ESHITA on 20/05/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    @ObservedObject var locationManager = LocationManager()
        
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            
            map.showsUserLocation = true
            map.delegate = context.coordinator
            print("from loc manager inside mapview \(self.locationManager.lastLocation.coordinate)")
            let region = MKCoordinateRegion(
                  center: CLLocationCoordinate2D(latitude: self.locationManager.lastLocation.coordinate.latitude, longitude: self.locationManager.lastLocation.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
              map.setRegion(region, animated: true)
            
        }
        return map
    }
    
    func makeCoordinator() -> Coordinator {
     Coordinator(self)
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
}
