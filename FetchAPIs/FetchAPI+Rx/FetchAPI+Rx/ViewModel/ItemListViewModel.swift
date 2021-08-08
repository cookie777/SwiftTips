//
//  ItemListViewModel.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit
import RxSwift
import RxCocoa

class ItemListViewModel {
  let disposedBag = DisposeBag()
  var peoples: [People] = []
  
  // output: model -> view
  var updatePeoples = BehaviorRelay<[People]>(value: [])
  var updateCellImageAt = PublishRelay<(Int, UIImage?)>()
  
  // input: view -> model
  var fetchCellImageAt = PublishRelay<Int>()
  
  
  init() {
    bindFetchCellImageAt()
  }
  
  // view -> api
  func fetchAllItems() {
    let url = URL(string: "https://rickandmortyapi.com/api/character")!
   APIRequest.shared.fetch(from: url)
    .subscribe { [weak self] (event: Event<Peoples>) in
      switch event {
        case .next(let peoples):
          self?.peoples.append(contentsOf: peoples.results)
          // api -> model -> ui
          self?.updatePeoples.accept(peoples.results)
        case .error(let e):
          debugPrint("error on fetching peoples. \(e.localizedDescription)")
        case .completed:
          debugPrint("completed fetching peoples")
      }
    }.disposed(by: disposedBag)
  }
  
  
  // view(cell) -> api
  func bindFetchCellImageAt() {
    
    fetchCellImageAt
      .flatMap({ [weak self] index -> Observable<(UIImage?, Int, NSURL, Error?)> in
        let id = index
        let url =  URL(string: (self?.peoples[id].image)!)! as NSURL
        debugPrint("will start fetching \(String(describing: url))")
        return APIRequest.shared.fetchImage(from: url as URL).map { image in
          (image, id, url, nil)
        }
        .catch { error in
          Observable.just((nil, id, url, error))
        }
      })
      .subscribe { [weak self] (image, index, url, error) in
        
        guard let image = image else {
          debugPrint("😭couldn't get image. \(url)")
          APIRequest.shared.requestCache.removeObject(forKey: url)
          self?.updateCellImageAt.accept((index, nil))
          return
        }
        
        if let error = error {
          debugPrint("something wrong happen. \(error.localizedDescription)")
          APIRequest.shared.requestCache.removeObject(forKey: url)
          self?.updateCellImageAt.accept((index, nil))
          return
        }
        
        APIRequest.shared.imageCache.setObject(image, forKey: url)
        debugPrint("🎉fetched image for \(url), \(index)")
        self?.updateCellImageAt.accept((index, image))
        
      }.disposed(by: disposedBag)

  }
}
