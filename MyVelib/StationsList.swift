//
//  StationsList.swift
//  MyVelib
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation

protocol StationsList {
  var allStations: [Station] { get }
  var shortStationsList: [Station] { get }
}

struct FavoriteStationsList: StationsList {
  weak var modelController: ModelController!
  
  let favoriteService: FavoriteService
  let favoriteList: FavoriteList
  let contractName: ContractName
  
  var allStations: [Station] { return modelController.stations }
  var shortStationsList: [Station] { 
    return allStations.filter { favoriteService.isFavorite(stationId: $0.number, contrat: contractName, list: favoriteList) }
  }
}

struct GeolocalisedStationsList: StationsList {
  weak var modelController: ModelController!
  
  let locationService: LocationService
  
  private let maximumDistance = 500.0
  
  var allStations: [Station] { return modelController.stations }
  var shortStationsList: [Station] { 
    return allStations.filter { locationService.distance(of: $0.position.coordinate) < maximumDistance }
  }
}

