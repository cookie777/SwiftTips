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
    
    viewModel.fetchItems { [weak self] in
      self?.tableView.reloadData()
    }
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
    cell.setUpImage(nil)
    
    // Fetch image if not feched
    if let fetchedImage = viewModel.fetchedImages[people.id] {
      cell.setUpImage(fetchedImage)
    } else {
      viewModel.fetchImage(url: people.image) { image in
        self.viewModel.fetchedImages[people.id] = image
        tableView.reloadRows(at: [indexPath], with: .none)
      }
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
