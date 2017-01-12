//
//  ListViewController.swift
//  MyVelib
//
//  Created by kpm on 12/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
  
  var index: Int = 0
  var list: StationsList! 
  private let listDataSource = ListDataSource()
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  class func instantiate() -> ListViewController {
    let storyboardIdentifier = "List"
    let storyboardName = "Main"
    return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier) as! ListViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    listDataSource.list = list
    tableView.dataSource = listDataSource
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    refreshUI()
  }
  
  func refreshUI() {
    titleLabel.text = list is FavoriteStationsList ? "Favoris" : "Géoloc"
    tableView.reloadData()
    view.backgroundColor = list.bikeAvailability.color
    print("Stations count: \(list.allStations.count)")
    print("Stations in short list: \(list.shortStationsList.count)")
  }
  
}

extension BikeAvailability {
  var color: UIColor {
    switch self {
    case .bad: return #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
    case .warning: return #colorLiteral(red: 0.8787227273, green: 0.4410843253, blue: 0, alpha: 1)
    case .good: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    case .undefined: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
  }
}

class ListDataSource: NSObject, UITableViewDataSource {
  var list: StationsList!
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.shortStationsList.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let station = list.shortStationsList[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)

    cell.textLabel?.text = station.name
    
    let distanceText: String
    if let list = list as? GeolocalisedStationsList {
      distanceText = "\(Int(list.distance(of: station))) m - " 
    } else {
      distanceText = ""
    }
    cell.detailTextLabel?.text = distanceText + "\(station.availableBikes) vélos - \(station.availableStands) places"

    return cell
  }

}
