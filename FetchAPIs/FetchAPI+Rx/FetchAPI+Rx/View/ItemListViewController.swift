//
//  ItemListTableViewController.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit
import RxSwift

class ItemListViewController: UIViewController {
  
  let viewModel = ItemListViewModel()
  let disposedBag = DisposeBag()
  let tableView: UITableView = {
    let tb = UITableView(frame: .zero, style: .grouped)
    tb.backgroundColor = .systemBackground
    tb.translatesAutoresizingMaskIntoConstraints = false
    tb.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
    return tb
  } ()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    
    // Api -> models
    viewModel.fetchAllItems()

    // models -> cell, UI
    viewModel.updatePeoples
      .bind(to: tableView.rx.items(cellIdentifier: ItemTableViewCell.identifier, cellType: ItemTableViewCell.self)) {(row, people, cell) in
        cell.setUpLayout(people)
        print(people.id)
        
      }.disposed(by: disposedBag)

    // cell -> Api(model)
    tableView.rx.willDisplayCell
      .filter { $0.cell.isKind(of: ItemTableViewCell.self) }
      .map {($0.cell as! ItemTableViewCell, $0.indexPath.row)}
      .do { (cell, index) in
        cell.setUpImage(UIImage.placeholder)
      }
      .subscribe(onNext: { [weak self] (cell, index) in
        let people = self?.viewModel.peoples[index]
        let url = URL(string: people!.image)! as NSURL
        debugPrint("start➡️  \(String(describing: people?.id))")
        // cache exist?
        if let cachedImage = APIRequest.shared.imageCache.object(forKey: url) {
          cell.setUpImage(cachedImage)
          debugPrint("👍used cache \(String(describing: people?.id))")
          return
        }
        
        cell.activityIndicator.startAnimating()
        // already requested?
        if let _ = APIRequest.shared.requestCache.object(forKey: url) {
          debugPrint("loading  \(String(describing: people?.id))")
          return
        }
        APIRequest.shared.requestCache.setObject(NSNull(), forKey: url)
        self?.viewModel.fetchCellImageAt.accept(index)
      }).disposed(by: disposedBag)
    

    // model -> view(cell)
    viewModel.updateCellImageAt
      .observe(on: MainScheduler.asyncInstance)
      .bind { [weak self] (index, image) in
        
        guard let cell = self?.tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? ItemTableViewCell else { return }

        
        if let image = image {
          cell.setUpImage(image)
          self?.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
          debugPrint("✅update cell for \(index)")
        }

        cell.activityIndicator.stopAnimating()

      }.disposed(by: disposedBag)
    
    
    tableView.rx.itemSelected
      .bind { [weak self] index in
        let vm = ItemDetailViewModel()
        let people = self?.viewModel.peoples[index.row]
        let url = URL(string: people!.image)! as NSURL
        
        vm.people = people
        
        // cache exist?
        if let cachedImage = APIRequest.shared.imageCache.object(forKey: url) {
          vm.fetchedImage = cachedImage
        }
        
        let nextVC = ItemDetailViewController(viewModel: vm)
        self?.navigationController?.pushViewController(nextVC, animated: true)
      }.disposed(by: disposedBag)
  }
}
