//
//  ItemListViewModel.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit
import RxSwift

class ItemListViewModel {
  let disposedBag = DisposeBag()
  var peoples: [People] = []
  var fetchedImages: [Int: UIImage?] = [:]
  
  func fetchAllItems() -> Observable<Void> {
    let url = URL(string: "https://rickandmortyapi.com/api/character")!
    
    return APIRequest.shared.fetch(from: url)
      .map { [weak self] (peoples: Peoples) in
        self?.peoples = peoples.results
      }
  }
  
  func fetchImage(id: Int, url: String) -> Observable<Void> {
    let url = URL(string: url)!
    return APIRequest.shared.fetchImage(from: url)
      .map { [weak self] image in
        self?.fetchedImages[id] = image
      }
  }
}
