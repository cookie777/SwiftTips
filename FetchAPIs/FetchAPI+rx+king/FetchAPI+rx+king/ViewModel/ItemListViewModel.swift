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
}
