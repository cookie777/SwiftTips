//
//  ItemDetailViewModel.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-02.
//

import UIKit
import RxSwift

class ItemDetailViewModel {
  let disposedBag = DisposeBag()
  
  var people: People!
  var fetchedImage: UIImage?

  func fetchItem() -> Observable<PeopleDetail> {
    let url = URL(string: "https://rickandmortyapi.com/api/character/\(people.id)")!
    
    return APIRequest.shared.fetch(from: url)
  }
    
}
