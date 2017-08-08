//
//  ModelController.swift
//  MyVelib
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation

class ModelController {
  private(set) var lists = [StationsList]()
  
  private let bikeService = BikeService()
  private let locationService = LocationService()
  private let favoriteService = FavoriteService()
  
  var currentContract: ContractName = "Paris"
  var contracts = [Contrat]()
  var stations = [Station]() 
  
  init() {
    let homeList = FavoriteStationsList(modelController: self, favoriteService: favoriteService, favoriteList: .home, contractName: currentContract)
    let workList = FavoriteStationsList(modelController: self, favoriteService: favoriteService, favoriteList: .work, contractName: currentContract)
    let geolocalisedList = GeolocalisedStationsList(modelController: self, locationService: locationService)
    lists = [ homeList, workList, geolocalisedList ]
  }
  
  func refreshStations(completion: @escaping CompletionBlock<Bool>) {
    bikeService.getStations(for: currentContract) { result in
      completion(result.map{ (stations) -> Bool in
        self.stations = stations
        return true
      })
    }
  }

  func refreshContracts(completion: @escaping CompletionBlock<Bool>) {
    bikeService.getContrats { result in
      completion(result.map{ (contrats) -> Bool in
        self.contracts = contrats
        return true
      })
    }
  }

}
