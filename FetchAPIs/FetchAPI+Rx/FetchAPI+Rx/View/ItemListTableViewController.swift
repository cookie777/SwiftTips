//
//  ItemListTableViewController.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit

class ItemListTableViewController: UITableViewController {
  
  let viewModel = ItemListViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
    subscribeItems()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.peoples.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell else { return UITableViewCell()}
    
    let people = viewModel.peoples[indexPath.row]
    cell.setUpLayout(people)
    
    // Reset previous image used as reusable cell
    cell.setUpImage(UIImage.placeholder)
    
    // Fetch image if not feched
    if let fetchedImage = viewModel.fetchedImages[people.id] {
      cell.setUpImage(fetchedImage)
    } else {
      subscribeImages(id: people.id, imageURL: people.image, indexPath: indexPath)
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // setup view model of next VC
    let nextVM = ItemDetailViewModel()
    let people = viewModel.peoples[indexPath.row]
    nextVM.people = people
    if let image = viewModel.fetchedImages[people.id] {
      nextVM.fetchedImage = image
    }
    let nextVC = ItemDetailViewController(viewModel: nextVM)
    
    navigationController?.pushViewController(nextVC, animated: true)
  }
  
}


// MARK: - subscribe

extension ItemListTableViewController {
  private func subscribeItems() {
    viewModel.fetchAllItems()
     .subscribe { [weak self] _ in
       DispatchQueue.main.async {
         self?.tableView.reloadData()
       }
     } onError: { error in
       debugPrint(error.localizedDescription)
     } onCompleted: {
       debugPrint("we fetched all items")
     }.disposed(by: viewModel.disposedBag)
  }
  
  private func subscribeImages(id: Int, imageURL: String, indexPath: IndexPath ) {
    viewModel.fetchImage(id: id, url: imageURL)
      .subscribe {[weak self] _ in
        DispatchQueue.main.async {
          self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
      } onError: { error in
        debugPrint(error.localizedDescription)
      } onCompleted: {
        debugPrint("\(id) is finished fetching image")
      }.disposed(by: viewModel.disposedBag)
  }
}
