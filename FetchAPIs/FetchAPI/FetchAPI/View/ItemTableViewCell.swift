//
//  ItemTableViewCell.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
  
  static let identifier = "item"
  
  func setUpLayout(_ people: People) {
    self.textLabel?.text = String(people.id)
  }
  
  func setUpImage(_ image: UIImage?) {
    self.imageView?.image = image
  }

}
