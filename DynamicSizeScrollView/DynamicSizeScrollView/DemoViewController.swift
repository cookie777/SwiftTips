//
//  ViewController.swift
//  DynamicSizeScrollView
//
//  Created by Takayuki Yamaguchi on 2021-06-15.
//

import UIKit

class DemoViewController: UIViewController {
  
  let scrollView = UIScrollView()
  let dynamicSizeContent = UIStackView(arrangedSubviews: [])
  
  let addViewButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.layer.borderColor = UIColor.darkText.cgColor
    view.layer.borderWidth = 2
    
    configureSuperView()
    configureAddViewButton()
    configureScrollView()
    configureDynamicSizeContent()
    
    for _ in 0..<40 {
      addDynamicContent()
    }
    
  }
  
  private func configureSuperView() {
    scrollView.addSubview(dynamicSizeContent)
    view.addSubview(scrollView)
    view.addSubview(addViewButton)
    
  }
  
  private func configureScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .systemFill
    let scrollViewMargin:CGFloat = 24
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: scrollViewMargin),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: scrollViewMargin),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -scrollViewMargin),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -scrollViewMargin)
    ])
  }
  
  private func configureDynamicSizeContent() {
    // Stack view basic configuration
    dynamicSizeContent.translatesAutoresizingMaskIntoConstraints = false
    dynamicSizeContent.backgroundColor = .systemTeal
    dynamicSizeContent.distribution = .fill
    dynamicSizeContent.spacing = 16
    dynamicSizeContent.axis = .vertical
    
    
    // Constraint
    let contentMargin:CGFloat = 24
    
    dynamicSizeContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2*contentMargin).isActive = true
 
    
    
    let sa = scrollView.contentLayoutGuide
    NSLayoutConstraint.activate([
      dynamicSizeContent.topAnchor.constraint(equalTo: sa.topAnchor, constant: contentMargin),
      dynamicSizeContent.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: contentMargin),
      dynamicSizeContent.trailingAnchor.constraint(equalTo: sa.trailingAnchor, constant: -contentMargin),
      dynamicSizeContent.bottomAnchor.constraint(equalTo: sa.bottomAnchor, constant: -contentMargin)
    ])
    
  }
  
  private func addDynamicContent() {
    
    let uiv = UIView()
    uiv.heightAnchor.constraint(equalToConstant: 40).isActive = true
    uiv.backgroundColor = .systemRed
    
    dynamicSizeContent.addArrangedSubview(uiv)
    
  }
  
  private func configureAddViewButton() {
    addViewButton.translatesAutoresizingMaskIntoConstraints = false
    addViewButton.setTitle("Add a view", for: .normal)
    addViewButton.setTitle("tapped", for: .highlighted)
    addViewButton.setTitleColor(.darkText, for: .normal)
    addViewButton.setTitleColor(.systemRed, for: .highlighted)
    addViewButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    NSLayoutConstraint.activate([
      addViewButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
      addViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
    ])
  }
  @objc func buttonTapped() {
    addDynamicContent()
  }
  
}

