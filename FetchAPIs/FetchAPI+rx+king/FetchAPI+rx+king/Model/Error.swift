//
//  Error.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import Foundation

enum NetworkError: Error {
  case client(message: String)
  case server
}

