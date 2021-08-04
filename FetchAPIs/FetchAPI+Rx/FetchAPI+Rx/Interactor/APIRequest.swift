//
//  APIRequset.swift
//  APIFetching
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit
import RxSwift
import RxCocoa

class APIRequest {
  static let shared = APIRequest()
  private init() { }
  private var dataTask: URLSessionDataTask?
}


// MARK: - Basic fetch

extension APIRequest {
  
  func fetch<T: Decodable>(from url: URL) -> Observable<T> {
    let request = URLRequest(url: url)
    
    return URLSession.shared.rx.response(request: request)
      .map { (response, data) -> T in
        // server error
        if !(200...299).contains(response.statusCode) {
          throw NetworkError.server
        }
        
        // decode error
        do {
          let decodable = try JSONDecoder().decode(T.self, from: data)
          return decodable
        } catch {
          // decode error
          throw NetworkError.client(message: "decode error")
        }
        
      }
  }
  
  
  func fetchImage(from url: URL) -> Observable<UIImage> {
    let request = URLRequest(url: url)
    
    return URLSession.shared.rx.response(request: request)
      .map { (response, data) -> UIImage in
        
        // server error
        if !(200...299).contains(response.statusCode) {
          throw NetworkError.server
        }
        
        // decode error
        guard let image = UIImage(data: data) else {
          throw NetworkError.client(message: "data error")
        }
        return image
      }
  }
}

