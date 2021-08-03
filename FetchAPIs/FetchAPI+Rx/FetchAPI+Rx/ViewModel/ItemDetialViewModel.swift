//
//  ItemDetailViewModel.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-02.
//

import UIKit

class ItemDetailViewModel {
  var people: People!
  var peopleDetail: PeopleDetail!
  var fetchedImage: UIImage?
  
  
  func fetchItem(completion: @escaping (PeopleDetail)->Void) {
    APIRequest.shared.fetchItem(id: people.id) { detail in
      DispatchQueue.main.async {
        completion(detail)
      }
    }
  }
  
  func fetchImage(completion: @escaping (UIImage?) -> Void) {
    APIRequest.shared.fetchImage(url: URL(string: people.image)!) { image in
      DispatchQueue.main.async {
        completion(image)
      }
    }
  }
    
}
