//
//  SectionItem.swift
//  FetchAPI+diffable
//
//  Created by Takayuki Yamaguchi on 2021-08-02.
//

import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

enum Section {
  case list
}

enum Item: Hashable {  
  case people(People)
}

extension Item {
  /// Get `User` model from Item
  var people: People? {
    get {
      if case let .people(c) = self {
        return c
      } else {
        return nil
      }
    }
  }
  /// Wrap multi User model into Items
  static func wrap(items: [People]) -> [Item] {
    return items.map {Item.people($0)}
  }
}
