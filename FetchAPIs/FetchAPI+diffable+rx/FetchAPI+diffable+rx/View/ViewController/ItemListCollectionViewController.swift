//
//  ItemListCollectionViewController.swift
//  FetchAPI+diffable
//
//  Created by Takayuki Yamaguchi on 2021-08-02.
//

import UIKit

class ItemListCollectionViewController: UICollectionViewController {
  
  let sections: [Section] = [.list]
  var dataSource: DataSource!
  let viewModel = ItemListViewModel()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionViewLayout()
    setUpDiffableDataSource()
    
    viewModel.fetchItems { [weak self] in
      guard let self = self else {return}
      self.dataSource.apply(self.viewModel.snapshot,animatingDifferences: false, completion: nil)
    }
  }
  
}



extension ItemListCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
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


// MARK: - Layout

extension ItemListCollectionViewController {
  func setUpCollectionViewLayout() {
    // Create list layout
    let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
    collectionView.collectionViewLayout = listLayout
  }
}

// MARK: - DataSource

extension ItemListCollectionViewController {
  func setUpDiffableDataSource(){
    
    // Create cell registration that defines how data should be shown in a cell
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { [weak self] (cell, indexPath, item) in
      
      guard let self = self else {return}
      
      // Define how data should be shown using content configuration
      var content = cell.defaultContentConfiguration()
      
      if let people = item.people {
        content.text =  people.id.description
        content.imageProperties.maximumSize = CGSize(width: 32, height: 32)
        
        // reset image
        content.image = UIImage.placeholder
        
        // Fetch image if not fetched
        if let fetchedImage = self.viewModel.fetchedImages[people.id] {
          content.image = fetchedImage
        } else {
          self.viewModel.fetchImage(url: people.image) { image in
            self.viewModel.fetchedImages[people.id] = image
            self.dataSource.apply(
              self.viewModel.snapshot,
              animatingDifferences: false,
              completion: nil
            )
          }
        }
        
      }
      // Assign content configuration to cell
      cell.contentConfiguration = content
    }
    
    dataSource = DataSource(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
      
      // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
      let cell = collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: identifier
      )
      // Configure cell appearance
      cell.accessories = [.disclosureIndicator()]
      
      return cell
    }
    
    // Display data in the collection view by applying the snapshot to data source
    dataSource.apply(viewModel.snapshot, animatingDifferences: false)
  }
}
