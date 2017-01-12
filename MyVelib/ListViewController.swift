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
  
  class func instantiate() -> ListViewController {
    let storyboardIdentifier = "List"
    let storyboardName = "Main"
    return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier) as! ListViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let type = list is FavoriteStationsList ? "Favoris" : "Géoloc"
    print("page #\(index) : \(type)")
    
    refreshUI()
  }
  
  func refreshUI() {
    print("Stations count: \(list.allStations.count)")
    print("Stations in short list: \(list.shortStationsList.count)")
  }
  
}
