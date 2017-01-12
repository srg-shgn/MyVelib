//
//  Entities.swift
//  MyVelib Corrigé
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation

typealias ContractName = String

struct Position {
  let lat: Double, lon: Double
}

struct Contrat {
  let name: ContractName 
  let commercialName: String
}

struct Station {
  let number: Int 
  let contractName: ContractName 
  let name: String 
  let description: String 
  let position: Position 
  let isOpen: Bool
  let availableStands: Int 
  let availableBikes: Int 
}


// JSONSerializable 

protocol JSONSerializable {
  associatedtype JSONType 
  init?(json: JSONType) 
}

extension Station: JSONSerializable {
  typealias JSONType = [String:Any]
  
  init?(json: JSONType) {
    guard let number = json["number"] as? Int, 
      let contractName = json["contract_name"] as? ContractName, 
      let name = json["name"] as? String,
      let description = json["address"] as? String, 
      let position = json["position"] as? [String:Double], 
      let lat = position["lat"], 
      let lon = position["lng"], 
      let status = json["status"] as? String,
      let isOpen = Station.parse(status: status), 
      let availableStands = json["available_bike_stands"] as? Int, 
      let availableBikes = json["available_bikes"] as? Int 
      else {
        return nil
    }
    
    self.number = number
    self.contractName = contractName
    self.name = name
    self.description = description
    self.position = Position(lat: lat, lon: lon)
    self.isOpen = isOpen
    self.availableStands = availableStands
    self.availableBikes = availableBikes
  }
  
  static func parse(status: String) -> Bool? {
    switch status {
    case "OPEN": return true 
    case "CLOSED": return false
    default: return nil
    }
  }
}

extension Contrat: JSONSerializable {
  typealias JSONType = [String:Any]
  
  init?(json: [String:Any]) {
    guard let name = json["name"] as? String, let commercialName = json["commercial_name"] as? String else { return nil }
    self.name = name
    self.commercialName = commercialName
  }
}

