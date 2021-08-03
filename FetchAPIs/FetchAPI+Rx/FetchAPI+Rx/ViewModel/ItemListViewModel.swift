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
  
  func fetchItems(completion: @escaping ()->Void) {
    APIRequest.shared.fetchAllItems { peoples in
      self.peoples = Array(peoples[0...19])
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
