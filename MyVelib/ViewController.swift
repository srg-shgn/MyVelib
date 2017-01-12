//
//  ViewController.swift
//  MyVelib Corrigé
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let modelController = ModelController()

  override func viewDidLoad() {
    super.viewDidLoad()
    modelController.refreshStations { (result) in
      DispatchQueue.main.async {
        switch result {
        case .failure(let error) : self.displayError(error)
        case .success: self.refreshUI()
        }
      }
    }
  }

  func displayError(_ error: Error) {
    print(error.localizedDescription)
  }

  func refreshUI() {
    print("Stations count: \(modelController.stations.count)")
    print("Stations near current position: \(modelController.currentShortStationsList.count)")
  }

}

