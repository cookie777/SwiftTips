//
//  ItemTableViewCell.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
  
  static let identifier = "item"
  
  // MARK: - Initialization
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(activityIndicator)
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setUpLayout(_ people: People) {
    self.textLabel?.text = String(people.id)
  }
  
  func setUpImage(_ image: UIImage?) {
    self.imageView?.image = image
  }
  
  lazy var activityIndicator: UIActivityIndicatorView = {
      let indicator = UIActivityIndicatorView()
      indicator.hidesWhenStopped = true
      indicator.center = self.contentView.center
      return indicator
  }()
  
  
}
