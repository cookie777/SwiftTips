//
//  TopTableViewController.swift
//  DynamicSizeScrollView
//
//  Created by Takayuki Yamaguchi on 2021-06-19.
//

import UIKit

class TopTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    switch indexPath.item {
      case 0:
        cell.textLabel?.text = "dynamic height scroll view"
      case 1:
        cell.textLabel?.text = "custom scroll view"
      default:
        break
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.item {
      case 0:
        navigationController?.pushViewController(DemoViewController(), animated: true)
      case 1:
        navigationController?.pushViewController(CustomClassViewController(), animated: true)
      default:
        break
    }
  }
}
