//
//  LocationService.swift
//  MyVelib Corrigé
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
  
  var currentLocation: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
  var isAuthorised = false { 
    didSet { 
      if isAuthorised {
        locationManager.startUpdatingLocation()
      } else {
        locationManager.stopUpdatingLocation()
      }
    } 
  }
  
  private let locationManager = CLLocationManager()
  
  override init() {
    super.init()
    locationManager.delegate = self

    if isAuthorised {
      locationManager.startUpdatingLocation()
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    currentLocation = locations.last?.coordinate ?? kCLLocationCoordinate2DInvalid
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    isAuthorised = (status == .authorizedWhenInUse)
  }
  
  func distance(of coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
    let currentLocation = CLLocation(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude)
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    return currentLocation.distance(from: location)
  }

}

extension Position {
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }
}
