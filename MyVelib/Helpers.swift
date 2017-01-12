//
//  Helpers.swift
//  MyVelib Corrigé
//
//  Created by kpm on 10/01/2017.
//  Copyright © 2017 3W Academy. All rights reserved.
//

import Foundation

typealias CompletionBlock<T> = (Result<T>)->()
//typealias OperationBlock<U> = (CompletionBlock<U>)->()

enum Result<T> {
  case success(T)
  case failure(Error)
}

extension Result {
  func map<U>(_ f: (T)->U) -> Result<U> {
    switch self {
    case .failure(let error): return .failure(error)
    case .success(let t): return .success(f(t))
    }
  }
  func flatMap<U>(_ f: (T)->Result<U>) -> Result<U> {
    switch self {
    case .failure(let error): return .failure(error)
    case .success(let t): return f(t)
    }
  }
}

extension Optional {
  func mapNil(to error: Error) -> Result<Wrapped> {
    switch self {
    case .none: return .failure(error)
    case .some(let value): return .success(value)
    }
  }
}

