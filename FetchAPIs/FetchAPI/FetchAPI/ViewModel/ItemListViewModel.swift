//
//  ItemListViewModel.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit

class ItemListViewModel {
  var peoples: [People] = []
  
  func fetchItems(completion: @escaping ()->Void) {
    APIRequest.shared.fetchAllItems { peoples in
      self.peoples = peoples
      DispatchQueue.main.async {
        completion()
      }
    }
  }
  
  func fetchImage(url: NSURL, completion: @escaping (UIImage?, FetchStatus) -> Void) {
    
    // If cache exist, try to use it.
    if let fetchedImage = APIRequest.shared.imageCache.object(forKey: url) {
      completion(fetchedImage, .hasCache)
      return
    }
    
    // If the request already exist, ignore.
    if let _ = APIRequest.shared.requestCache.object(forKey: url) {
      return
    } else {
      APIRequest.shared.requestCache.setObject(ImageRequest(completion), forKey: url)
    }
    
    APIRequest.shared.fetchImage(url: url as URL) { image in
      // request fail, remove request from the list
      guard let image = image else {
        APIRequest.shared.requestCache.removeObject(forKey: url)
        return
      }
      
      APIRequest.shared.imageCache.setObject(image, forKey: url)
      
      if let completion = APIRequest.shared.requestCache.object(forKey: url)?.completion {
        APIRequest.shared.requestCache.removeObject(forKey: url)
        DispatchQueue.main.async {
          completion(image, .loaded)
        }
      }
    }
  }

}
