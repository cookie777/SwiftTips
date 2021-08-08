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
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    32
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell else { return UITableViewCell()}
    
    let people = viewModel.peoples[indexPath.row]
    cell.setUpLayout(people)
    
    // Reset previous image for reusable cell
    cell.setUpImage(UIImage.placeholder)
    
    // Fetch image
    let url = URL(string: people.image)! as NSURL
    viewModel.fetchImage(url: url) { image, status in
      switch status {
        case .loaded:
          // This will call `cellForRowAt` again.
          tableView.reloadRows(at: [indexPath], with: .none)
        case .loading:
          break
        case .hasCache:
          cell.setUpImage(image)
      }
    }
    
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // setup view model of next VC
    let nextVM = ItemDetailViewModel()
    let people = viewModel.peoples[indexPath.row]
    nextVM.people = people
    
    let url = URL(string: people.image)!
    if let image = APIRequest.shared.imageCache.object(forKey: url as NSURL) {
      nextVM.fetchedImage = image
    }
    APIRequest.shared.customUrlSession.getAllTasks { allTasks in
      allTasks.forEach { task in
        task.cancel()
      }
    }
    let nextVC = ItemDetailViewController(viewModel: nextVM)
    
    navigationController?.pushViewController(nextVC, animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
}
