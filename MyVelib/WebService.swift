//
//  WebService.swift
//  MyVelib Corrigé
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation

class WebService {
  
  let baseURL: URL
  let defaultQuery: [String:String]
  
  init(baseURL: URL, defaultQuery: [String:String]) {
    self.baseURL = baseURL
    self.defaultQuery = defaultQuery
  }
  
  func getResource<T>(at path: String, withArguments arguments:[String:String] = [:], completion:@escaping CompletionBlock<T>) {
    let query = defaultQuery.updating(with: arguments)
    let url = baseURL.appendingPathComponent(path).appendingQuery(query)
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      do {
        if let error = error { throw error }
        guard let response = response as? HTTPURLResponse else { throw WebServiceError.badRequest }
        let statusCode = response.statusCode
        guard statusCode == 200 else { throw WebServiceError.serverError(code: statusCode) }
        guard let data = data else { throw WebServiceError.noData }
        let json = try JSONSerialization.jsonObject(with: data) 
        guard let parsedJSON = json as? T else { throw WebServiceError.malformedJSON }
        completion(.success(parsedJSON))
        
      } catch {
        completion(.failure(error))
      }
      }.resume()
  }
  
  enum WebServiceError: LocalizedError {
    case badRequest
    case serverError(code: Int)
    case noData
    case malformedJSON
    
    public var errorDescription: String? { 
      switch self {
      case .badRequest: return "Bad Request"
      case .serverError(let code): return "Server error \(code)"
      case .noData: return "No Data"
      case .malformedJSON: return "Malformed JSON"
      }
    }
    
  }
}

extension URL {
  func appendingQuery(_ query:[String:String]) -> URL {
    var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
    urlComponents.query = query.map { $0.key + "=" + $0.value }.joined(separator: "&")
    return urlComponents.url!
  }
}

extension Dictionary {
  mutating func update(with otherDictionary: Dictionary) {
    otherDictionary.forEach { key, value in
      self[key] = value
    }
  }
  func updating(with otherDictionary: Dictionary) -> Dictionary {
    var newDictionary = self
    newDictionary.update(with: otherDictionary)
    return newDictionary
  }
}
