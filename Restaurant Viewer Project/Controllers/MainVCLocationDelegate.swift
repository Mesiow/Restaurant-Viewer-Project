//
//  MainVCLocationDelegate.swift
//  Restaurant Viewer Project
//
//  Created by Chris W on 1/31/25.
//

import UIKit
import CoreLocation

extension MainVC: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("in use")
            manager.startUpdatingLocation()
            
        case .denied, .restricted:
            self.presentAlertOnMainThread(title: "Location Permission Denied", message: "Enable location services in settings")
            
        case .notDetermined:
            print("not determined")
            manager.requestWhenInUseAuthorization()
            
        @unknown default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //stop updating once we get the first location
            locationManager.stopUpdatingLocation()
            currentLocation = location
            
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            fetchRestaurantDataAtLocation(latitude: lat, longitude: long)
        }
    }
}
