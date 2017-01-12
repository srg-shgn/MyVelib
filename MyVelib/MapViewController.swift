//
//  MapViewController.swift
//  MyVelib
//
//  Created by kpm on 12/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
  
  var list: StationsList! 
  var stationToShow: Station?

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    print("\(list.allStations.count) stations")
    print("station to show: \(stationToShow?.name ?? "NONE")")
  }
  
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }

}
