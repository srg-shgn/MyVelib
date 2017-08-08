//
//  FavoriteService.swift
//  MyVelib Corrigé
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation

enum FavoriteList: String {
  case home, work
}

class FavoriteService {
  private let userDefaults = UserDefaults.standard
  
  func isFavorite(stationId: Int, contrat: ContractName, list: FavoriteList) -> Bool {
    return favorites(contrat: contrat, list: list).contains(stationId)
  }
  
  func addFavorite(stationId: Int, contrat: ContractName, list: FavoriteList) {
    var favorites = self.favorites(contrat: contrat, list: list)
    favorites.insert(stationId)
    saveFavorites(favorites, contrat: contrat, list: list)
  }
  
  func removeFavorite(stationId: Int, contrat: ContractName, list: FavoriteList) {
    var favorites = self.favorites(contrat: contrat, list: list)
    favorites.remove(stationId)
    saveFavorites(favorites, contrat: contrat, list: list)
  }
  
  private func favorites(contrat: ContractName, list: FavoriteList) -> Set<Int> {
    let key = self.key(for: contrat, list: list)
    let array = userDefaults.array(forKey: key) as? [Int] ?? []
    return Set(array)
  }
  
  private func saveFavorites(_ favorites: Set<Int>, contrat: ContractName, list: FavoriteList) {
    let key = self.key(for: contrat, list: list)
    userDefaults.set(Array(favorites), forKey: key)
  }
  
  private func key(for contrat: ContractName, list: FavoriteList) -> String {
    return list.rawValue + "." + contrat
  }
  
}
