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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    refreshUI()
  }
  
  func refreshUI() {
    titleLabel.text = list is FavoriteStationsList ? "Favoris" : "Géoloc"
    tableView.reloadData()
    print("Stations count: \(list.allStations.count)")
    print("Stations in short list: \(list.shortStationsList.count)")
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
    return cell
  }

}
