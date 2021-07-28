//
//  ViewController.swift
//  ReactiveKeyboardHeight
//
//  Created by Takayuki Yamaguchi on 2021-07-19.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  let textField = UITextField()
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayout()
    setUpBinding()
  }
}

extension ViewController {
  private func setUpLayout() {
    view.backgroundColor = .systemBackground
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = .systemGray5
    textField.text = "textField"
    view.addSubview(textField)
    NSLayoutConstraint.activate([
      textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
      textField.widthAnchor.constraint(equalToConstant: 120),
      textField.heightAnchor.constraint(equalToConstant: 32)
    ])
    
  }
}

extension ViewController {
  private func setUpBinding() {
    
    // When enter, dismiss keyboard
    textField.rx
      .controlEvent(.editingDidEndOnExit)
      .bind { }
      .disposed(by: disposeBag)
    
    // Add Gesture: when tap out of keyboard, dismiss it
    let tapGesture = UITapGestureRecognizer()
    view.addGestureRecognizer(tapGesture)
    tapGesture.rx.event
      .bind { [weak self] _ in
        self?.view.endEditing(true)
      }
      .disposed(by: disposeBag)
    
    
    // Emit height when keyboard shows
    let willShownObservable = NotificationCenter.default
      .rx.notification(UIResponder.keyboardWillShowNotification)
      .compactMap({ notification -> CGRect? in
        notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
      })
      .map { rect in
        return rect.height
      }
    
    // Emit 0 when keyboard dismiss
    let willHideObservable = NotificationCenter.default
      .rx.notification(UIResponder.keyboardWillHideNotification)
      .map { _ -> CGFloat in
        return 0
      }
    
    // combine observables and bind to transform
    Observable.of(willShownObservable, willHideObservable)
      .merge()
      .bind { [weak view = self.view] height in
        view?.transform = CGAffineTransform(translationX: 0, y: -height)
      }
      .disposed(by: disposeBag)

  }
  
  func a()  {
    self.textField.text = "aaa"
  }
}
