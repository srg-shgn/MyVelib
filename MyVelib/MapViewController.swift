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
    
    mapView.delegate = self
    mapView.showsUserLocation = true
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
  
  @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
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

class StationAnnotationView: MKAnnotationView {
  let label = UILabel(frame: CGRect(x: 0, y: -8, width: 36, height: 38))
  
  init(annotation: StationAnnotation) {
    super.init(annotation: annotation, reuseIdentifier: "station")
    image = #imageLiteral(resourceName: "station_grise")
    label.text = "\(annotation.station.availableBikes)"
    label.textAlignment = .center
    label.textColor = .white
    centerOffset = CGPoint(x: 0, y: -20)
    addSubview(label)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? StationAnnotation else { return nil }
    let annotationView: StationAnnotationView
    if let reusedView = mapView.dequeueReusableAnnotationView(withIdentifier: "station") as? StationAnnotationView {
      annotationView = reusedView
    } else {
      annotationView = StationAnnotationView(annotation: annotation)
    }
    return annotationView
  }
}


