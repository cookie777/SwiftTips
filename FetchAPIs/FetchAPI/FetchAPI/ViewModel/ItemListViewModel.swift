//
//  ItemListViewModel.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit

class ItemListViewModel {
  var peoples: [People] = []
  let imageCache = NSCache<NSURL, UIImage>()
  let requestCache = NSCache<NSURL, NSNull>()
  
  func fetchItems(completion: @escaping ()->Void) {
    APIRequest.shared.fetchAllItems { peoples in
      self.peoples = peoples
      DispatchQueue.main.async {
        completion()
      }
    }
  }
  
  func fetchImage(url: NSURL, completion: @escaping (UIImage?, Status) -> Void) {
    
    if let fetchedImage = imageCache.object(forKey: url) {
      completion(fetchedImage, .hasCache)
      return
    }
    
    if let _ = requestCache.object(forKey: url) {
      completion(nil, .loading)
      return
    }

    requestCache.setObject(NSNull(), forKey: url)
    APIRequest.shared.fetchImage(url: url as URL) { image in
      guard let image = image else { return }
      self.imageCache.setObject(image, forKey: url)
      self.requestCache.removeObject(forKey: url)
      DispatchQueue.main.async {
        completion(image, .loaded)
      }
    }
  }
  
  enum Status {
    case loaded, loading, hasCache
  }
}
