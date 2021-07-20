//
//  DynamicHeightScrollView.swift
//  Queens-game
//
//  Created by Takayuki Yamaguchi on 2021-06-17.
//

import UIKit

open class DynamicHeightScrollView: UIScrollView {
  
  var contentView: UIView?
  
  // Default init with no content View
  init() {
    self.contentView = nil
    super.init(frame: .zero)
  }
  
  // Custom init with configuring content View  and padding
  init(contentView: UIView, padding: UIEdgeInsets = .zero) {
    self.contentView = contentView
    super.init(frame: .zero)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    configureContentView(padding)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureContentView(_ inset: UIEdgeInsets) {
    guard let contentView = contentView else { return }
    self.addSubview(contentView)
    
    // This will set the content  view's width
    contentView.widthAnchor.constraint(
      equalTo: self.widthAnchor,
      multiplier: 1,
      constant: -(inset.left + inset.right)
    ).isActive = true
    
    // This will create scroll view's `contentSize` equal to content view.
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(
        equalTo: contentLayoutGuide.topAnchor,
        constant: inset.top
      ),
      contentView.leadingAnchor.constraint(
        equalTo: contentLayoutGuide.leadingAnchor,
        constant: inset.left
      ),
      contentView.trailingAnchor.constraint(
        equalTo: contentLayoutGuide.trailingAnchor,
        constant: -inset.right
      ),
      contentView.bottomAnchor.constraint(
        equalTo: contentLayoutGuide.bottomAnchor,
        constant: -inset.bottom
      )
    ])
    
  }
}

