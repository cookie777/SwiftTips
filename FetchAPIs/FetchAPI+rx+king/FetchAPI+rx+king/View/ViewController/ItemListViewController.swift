//
//  ItemListTableViewController.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit
import RxSwift
import Kingfisher

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
    KingfisherManager.shared.downloader.downloadTimeout = 7
    
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
      }.disposed(by: disposedBag)
    
    // cell -> Api(model)
    tableView.rx.willDisplayCell
      .filter { $0.cell.isKind(of: ItemTableViewCell.self) }
      .map {($0.cell as! ItemTableViewCell, $0.indexPath.row)}
      .subscribe(onNext: { [weak self] (cell, index) in
        
        let people = self?.viewModel.peoples[index]
        let url = URL(string: people!.image)!
        
        cell.imageView?.kf.indicatorType = .activity
        
        KF.url(url)
          .placeholder(UIImage.placeholder)
          .setProcessor(RoundCornerImageProcessor(cornerRadius: 100))
          .fade(duration: 3)
          .cacheOriginalImage()
          .loadDiskFileSynchronously()
          .onProgress { (received, total) in print(" \(received)/\(total)") }
          .onSuccess { print($0) }
          .onFailure { err in print("Error: \(err)") }
          .set(to: cell.imageView!)
        
      }).disposed(by: disposedBag)
    
    
    tableView.rx.itemSelected
      .bind { [weak self] index in
        let vm = ItemDetailViewModel()
        let people = self?.viewModel.peoples[index.row]
        vm.people = people
        
        let nextVC = ItemDetailViewController(viewModel: vm)
        self?.navigationController?.pushViewController(nextVC, animated: true)
      }.disposed(by: disposedBag)
  }
}
