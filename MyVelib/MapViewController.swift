//
//  MapViewController.swift
//  MyVelib
//
//  Created by kpm on 12/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import UIKit
import MapKit

enum DisplayMode: Int { case bikes, stands }

class MapViewController: UIViewController {
  
  var list: StationsList! 
  var stationToShow: Station?
  var displayMode = DisplayMode.bikes

  @IBOutlet weak var mapView: MKMapView!
  
  
  //MARK: - View Life Cycle 
  
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
  

  //MARK: - IBAction 

  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
    guard let displayMode = DisplayMode(rawValue: sender.selectedSegmentIndex) else { return }
    self.displayMode = displayMode
    mapView.annotations.flatMap { $0 as? StationAnnotation }.forEach { $0.displayMode = displayMode ; $0.updateView(in: mapView) }
  }

  
  //MARK: - Private functions 

  private func centerMap(at coordinate: CLLocationCoordinate2D) {
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: false)
  }
}


//MARK: - StationAnnotation

class StationAnnotation: NSObject, MKAnnotation {
  let station: Station
  var displayMode: DisplayMode = .bikes
  
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
  
  func updateView(in mapView: MKMapView) {
    (mapView.view(for: self) as? StationAnnotationView)?.updateUI()
  }

}


//MARK: - StationAnnotationView 

class StationAnnotationView: MKAnnotationView {
  let label = UILabel(frame: CGRect(x: 0, y: -8, width: 36, height: 38))
  let favoriteButton = UIButton(type: .custom)

  override var annotation: MKAnnotation? { didSet { updateUI() } }
  var isFavorite: Bool = false { 
    didSet { 
      favoriteButton.isSelected = isFavorite 
      image = isFavorite ? #imageLiteral(resourceName: "station_orange") : #imageLiteral(resourceName: "station_grise") 
    } 
  }
  
  init(annotation: StationAnnotation, withFavoriteButton: Bool = false) {
    super.init(annotation: annotation, reuseIdentifier: "station")
    
    image = #imageLiteral(resourceName: "station_grise")
    label.textAlignment = .center
    label.textColor = .white
    addSubview(label)

    canShowCallout = true //autorise l'affichage de l'annotation
    centerOffset = CGPoint(x: 0, y: -20)
    
    if withFavoriteButton {
      favoriteButton.setImage(#imageLiteral(resourceName: "favourite-off"), for: .normal)
      favoriteButton.setImage(#imageLiteral(resourceName: "favourite-on"), for: .selected)
      favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
      rightCalloutAccessoryView = favoriteButton
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateUI() {
    guard let annotation = annotation as? StationAnnotation else { return }
    label.text = (annotation.displayMode == .bikes) ? "\(annotation.station.availableBikes)" : "\(annotation.station.availableStands)"
  }
}


//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? StationAnnotation else { return nil }
    let annotationView: StationAnnotationView
    if let reusedView = mapView.dequeueReusableAnnotationView(withIdentifier: "station") as? StationAnnotationView {
      annotationView = reusedView
    } else {
      let favoriteEnabled = (list is FavoriteStationsList)
      annotationView = StationAnnotationView(annotation: annotation, withFavoriteButton: favoriteEnabled)
    }
    
    if let list = list as? FavoriteStationsList {
      let isFavorite = list.isFavorite(station: annotation.station)
      annotationView.isFavorite = isFavorite
    }
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotationView = view as? StationAnnotationView, let annotation = annotationView.annotation as? StationAnnotation else { return }
    guard let list = list as? FavoriteStationsList else { return }
    list.toggleFavorite(station: annotation.station)
    annotationView.isFavorite = list.isFavorite(station: annotation.station)
  }

}


