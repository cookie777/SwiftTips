//
//  People.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit

struct Peoples: Codable {
  var results: [People]
}

struct People: Codable {
  var id: Int
  var name: String
  var image: String
}

struct PeopleDetail: Codable {
  var id: Int
  var name: String
  var image: String
  var status: String
  var species: String
}

extension People: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
  }
  static func == (lhs: People, rhs: People) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
