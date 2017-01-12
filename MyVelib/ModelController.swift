//
//  ModelController.swift
//  MyVelib
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation

class ModelController {
  private var lists = [StationsList]()
  var currentListIndex = 2
  var currentShortStationsList: [Station] { return lists[currentListIndex].shortStationsList }
  
  private let bikeService = BikeService()
  private let locationService = LocationService()
  private let favoriteService = FavoriteService()
  
  var currentContract: ContractName = "Paris"
  var contracts = [Contrat]()
  var stations = [Station]() {
    didSet {
      updateLists()
    }
  }
  
  func updateLists() {
    let homeList = FavoriteStationsList(allStations: stations, favoriteService: favoriteService, favoriteList: .home, contractName: currentContract)
    let workList = FavoriteStationsList(allStations: stations, favoriteService: favoriteService, favoriteList: .work, contractName: currentContract)
    let geolocalisedList = GeolocalisedStationsList(allStations: stations, locationService: locationService)
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
