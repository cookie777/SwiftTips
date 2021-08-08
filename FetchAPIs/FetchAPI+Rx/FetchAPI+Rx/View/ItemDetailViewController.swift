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
  
    subscribeImage()
    subscribeDetail()
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
  
  private func updateImage(image: UIImage?) {
    DispatchQueue.main.async {
      self.profileImage.image = image
    }
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
  
  private func subscribeImage() {
    if let image = viewModel.fetchedImage {
      updateImage(image: image)
      return 
    }
    
    let url = URL(string: viewModel.people.image)!
    APIRequest.shared.fetchImage(from: url)
      .subscribe { [weak self] image in
        self?.updateImage(image: image)
        self?.viewModel.fetchedImage = image
        APIRequest.shared.imageCache.setObject(image, forKey: url as NSURL)
        APIRequest.shared.requestCache.removeObject(forKey: url as NSURL)
      } onError: { error in
        debugPrint(error.localizedDescription)
        APIRequest.shared.requestCache.removeObject(forKey: url as NSURL)
      } onCompleted: {
        debugPrint("detail has fetched")
      }.disposed(by: viewModel.disposedBag)
  }
}
