//
//  MapRouteView.swift
//  Route-Search
//
//  Created by ESHITA on 20/05/21.
//

import SwiftUI
import MapKit

struct MapRouteView: UIViewRepresentable {
    
    @EnvironmentObject var currentRouteLoc : CurrentRouteLocation
    @ObservedObject var locationManager = LocationManager()
      
      
      func makeUIView(context: Context) -> MKMapView {
          let map = MKMapView()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
            
            map.showsUserLocation = true
            map.delegate = context.coordinator

            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: self.locationManager.lastLocation.coordinate.latitude, longitude: self.locationManager.lastLocation.coordinate.longitude),
                  span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            map.setRegion(region, animated: true)
            
            
            print("Current Latitude: \(self.locationManager.lastLocation.coordinate.latitude)")
            
            print("Current Longitude: \(self.locationManager.lastLocation.coordinate.longitude)")
            
            print("Searched Latitude: \(currentRouteLoc.searchedLatitude)")
            
            print("Searched Longitude: \(currentRouteLoc.searchedLongitude)")
            
            if( currentRouteLoc.searchedLatitude != 0.0 && currentRouteLoc.searchedLongitude != 0.0 ){
                
                let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:self.locationManager.lastLocation.coordinate.latitude, longitude: self.locationManager.lastLocation.coordinate.longitude))

                let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentRouteLoc.searchedLatitude, longitude: currentRouteLoc.searchedLongitude))

                  let request = MKDirections.Request()
                  request.source = MKMapItem(placemark: p1)
                  request.destination = MKMapItem(placemark: p2)
                  request.transportType = .automobile

                  let directions = MKDirections(request: request)
                  directions.calculate { response, error in
                    guard let route = response?.routes.first else { return }
                    map.addAnnotations([p1, p2])
                    map.addOverlay(route.polyline)
                    map.setVisibleMapRect(
                      route.polyline.boundingMapRect,
                      edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                      animated: true)
                  }
            }
            
        }
          
          
          return map
      }
      
      func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
      }
      func updateUIView(_ uiView: MKMapView, context: Context) {
          
      }
      
      class MapViewCoordinator: NSObject, MKMapViewDelegate {
          func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(red: 0.3333, green: 0.5098, blue: 0.1216, alpha: 0.85)
            renderer.lineWidth = 5
            return renderer
          }
        }
  }
