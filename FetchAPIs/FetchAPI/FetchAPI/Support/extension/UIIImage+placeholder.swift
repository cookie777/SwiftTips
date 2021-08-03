//
//  UIImage+placeholder.swift
//  FetchAPI
//
//  Created by Takayuki Yamaguchi on 2021-08-02.
//

import UIKit

extension UIImage {
  static let placeholder = UIImage.withColor(.magenta, size: CGSize(width: 32, height: 32))
  
  public static func withColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    let image =  UIGraphicsImageRenderer(size: size, format: format).image { rendererContext in
      color.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
    }
    return image
  }
}
