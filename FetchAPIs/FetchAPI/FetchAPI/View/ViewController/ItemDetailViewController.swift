//
//  ItemDetailViewController.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-02.
//

import UIKit

class ItemDetailViewController: UIViewController {
  var viewModel: ItemDetailViewModel!
  
  let profileImage = UIImageView()
  let idLabel = UILabel()
  let nameLabel = UILabel()
  let statusLabel = UILabel()
  let speciesLabel = UILabel()
  
  
  lazy var stackView: UIStackView = {
    let sv = UIStackView(
      arrangedSubviews: [
        profileImage,
        idLabel,
        nameLabel,
        statusLabel,
        speciesLabel
      ]
    )
    sv.translatesAutoresizingMaskIntoConstraints = false
    sv.axis = .vertical
    return sv
  }()
  
  
  init(viewModel: ItemDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayout()
    setUpUI()
    
    // Fetch and update UI
    viewModel.fetchItem { [weak self] detail in
      self?.updateDetail(detail: detail)
    }
    
    viewModel.fetchImage { [weak self] image in
      self?.updateImage(image: image)
    }
    
  }
  
  func setUpLayout() {
    view.backgroundColor = .systemBackground
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
  
  func setUpUI() {
    idLabel.text = viewModel.people.id.description
    nameLabel.text = viewModel.people.name
  }
  
  func updateDetail(detail: PeopleDetail) {
    statusLabel.text = detail.status
    speciesLabel.text = detail.species
  }
  
  func updateImage(image: UIImage?) {
    profileImage.image = image
  }
  
  
}
