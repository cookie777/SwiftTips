//
//  ItemListViewModel.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit

class ItemListViewModel {
  var peoples: [People] = []
  var fetchedImages: [Int: UIImage?] = [:]
  var snapshot: Snapshot!
  init() {
    // Create a snapshot that define the current state of data source's data
    snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections([.list])
    snapshot.appendItems(Item.wrap(items: []), toSection: .list)
  }
  
  func fetchItems(completion: @escaping ()->Void) {
    APIRequest.shared.fetchAllItems { peoples in
      self.peoples = peoples
      self.snapshot.deleteAllItems()
      self.snapshot.appendSections([.list])
      self.snapshot.appendItems(Item.wrap(items: peoples), toSection: .list)
      DispatchQueue.main.async {
        completion()
      }
    }
  }
  
  func fetchImage(url: String, completion: @escaping (UIImage?) -> Void) {
    APIRequest.shared.fetchImage(url: URL(string: url)!) { image in
      DispatchQueue.main.async {
        completion(image)
      }
    }
  }
}
