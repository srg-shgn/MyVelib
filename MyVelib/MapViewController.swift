//
//  MapViewController.swift
//  MyVelib
//
//  Created by kpm on 12/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  var list: StationsList! 
  var stationToShow: Station?

  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.addAnnotations(list.allStations.map(StationAnnotation.init))
    
    if let stationToShow = stationToShow {
      centerMap(at: stationToShow.position.coordinate)
      let selectedAnnotation = mapView.annotations.flatMap { $0 as? StationAnnotation }.filter { $0.station.number == stationToShow.number }.first!
      mapView.selectAnnotation(selectedAnnotation, animated: false)
    } else if list.shortStationsList.count > 0 {
      centerMap(at: list.shortStationsList[0].position.coordinate)
    } else {
      centerMap(at: list.allStations[0].position.coordinate)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    print("\(list.allStations.count) stations")
    print("station to show: \(stationToShow?.name ?? "NONE")")
  }
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }

  func centerMap(at coordinate: CLLocationCoordinate2D) {
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: false)
  }
}

class StationAnnotation: NSObject, MKAnnotation {
  let station: Station
  
  init(station: Station) {
    self.station = station
    super.init()
  }
  
  var coordinate: CLLocationCoordinate2D { 
    return station.position.coordinate
  }
  
  var title: String? { 
    return station.name
  }

}
