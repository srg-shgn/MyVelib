//
//  BikeService.swift
//  MyVelib Corrigé
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation

class BikeService {
  let webService: WebService
  
  init() {
    let baseURL = URL(string: "https://api.jcdecaux.com/vls/v1/")!
    let defaultQuery = ["apiKey": ""]
    webService = WebService(baseURL: baseURL, defaultQuery: defaultQuery)
  }
  
  func getContrats(completion: @escaping CompletionBlock<[Contrat]>) {
    webService.getResource(at: "contracts") { (result: Result<[Contrat.JSONType]>) in
      completion(result.map { $0.flatMap(Contrat.init) })
    }
  }
  
  func getStations(for contrat: ContractName, completion: @escaping CompletionBlock<[Station]>) {
    webService.getResource(at: "stations", withArguments: ["contract":contrat]) { (result: Result<[Station.JSONType]>) in
      completion(result.map { $0.flatMap(Station.init)})
    }
  }
  
  func updateStation(_ station: Station, completion: @escaping CompletionBlock<Station>) {
    let path = "stations/\(station.number)"
    webService.getResource(at: path, withArguments: ["contract":station.contractName]) { (result: Result<Station.JSONType>) in
      completion(result.flatMap { Station(json: $0).mapNil(to: WebService.WebServiceError.malformedJSON) })
    }
  }
  
}
