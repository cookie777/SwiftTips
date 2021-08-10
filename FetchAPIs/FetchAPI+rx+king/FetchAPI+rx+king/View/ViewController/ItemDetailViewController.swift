//
//  ItemDetailViewController.swift
//  APIFetchDefault
//
//  Created by Takayuki Yamaguchi on 2021-08-02.
//

import UIKit
import Kingfisher

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
  
    subscribeDetail()
    setUpImage()
  }
}



// MARK: - Layout & UI

extension ItemDetailViewController {
  private func setUpLayout() {
    view.backgroundColor = .systemBackground
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
  
  private func setUpUI() {
    idLabel.text = viewModel.people.id.description
    nameLabel.text = viewModel.people.name
  }
  
  private func updateDetail(detail: PeopleDetail) {
    DispatchQueue.main.async {
      self.statusLabel.text = detail.status
      self.speciesLabel.text = detail.species
    }
    
  }
  
  private func setUpImage() {
    profileImage.kf.setImage(
      with: URL(string: viewModel.people.image),
      placeholder: UIImage.placeholder,
        options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ],
        progressBlock: { receivedSize, totalSize in
            // Progress updated
        },
        completionHandler: { result in
            // Done
        }
    )
  }

}


// MARK: - Subscribe

extension ItemDetailViewController {
  private func subscribeDetail() {
    // Fetch and update UI
    viewModel.fetchItem()
      .subscribe { [weak self] detail in
        self?.updateDetail(detail: detail)
      } onError: { error in
        debugPrint(error.localizedDescription)
      } onCompleted: {
        debugPrint("detail has fetched")
      }.disposed(by: viewModel.disposedBag)
  }
}
