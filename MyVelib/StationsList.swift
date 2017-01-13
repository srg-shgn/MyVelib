//
//  StationsList.swift
//  MyVelib
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation

enum BikeAvailability {
  case bad, warning, good, undefined
}

protocol StationsList {
  var allStations: [Station] { get }
  var shortStationsList: [Station] { get }
  var bikeAvailability: BikeAvailability { get }
}

extension StationsList {
  var bikeAvailability: BikeAvailability {
    guard shortStationsList.count > 0 else { return .undefined }
    let totalBikeNumber = shortStationsList.map { $0.availableBikes }.reduce(0,+)
    let reallyAvailableStations = shortStationsList.filter { $0.availableBikes > 1 }.count
    switch (totalBikeNumber, reallyAvailableStations) {
    case (0, _): return .bad
    case (_, 0): return .warning
    default: return .good
    }
  }
}

struct FavoriteStationsList: StationsList {
  weak var modelController: ModelController!
  
  let favoriteService: FavoriteService
  let favoriteList: FavoriteList
  let contractName: ContractName
  
  var allStations: [Station] { return modelController.stations }
  var shortStationsList: [Station] { 
    return allStations.filter { isFavorite(station: $0) }
  }
  
  func isFavorite(station: Station) -> Bool {
    return favoriteService.isFavorite(stationId: station.number, contrat: contractName, list: favoriteList)
  }
  
  func toggleFavorite(station: Station) {
    let isFavorite = self.isFavorite(station: station)
    if isFavorite {
      favoriteService.removeFavorite(stationId: station.number, contrat: contractName, list: favoriteList)
    } else {
      favoriteService.addFavorite(stationId: station.number, contrat: contractName, list: favoriteList)
    }
  }
}

struct GeolocalisedStationsList: StationsList {
  weak var modelController: ModelController!
  
  let locationService: LocationService
  
  private let maximumDistance = 500.0
  
  var allStations: [Station] { return modelController.stations }
  var shortStationsList: [Station] { 
    return Array(allStations.filter { locationService.distance(of: $0.position.coordinate) < maximumDistance }.sorted(by: distance).prefix(5))
  }
  
  private func distance(lhs: Station, rhs: Station) -> Bool {
    return distance(of: lhs) < distance(of: rhs)
  }
  
  func distance(of station: Station) -> Double {
    return locationService.distance(of: station.position.coordinate)
  }
}

