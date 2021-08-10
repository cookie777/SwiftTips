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
  
  let imageCache = NSCache<NSURL, UIImage>()
  let requestCache = NSCache<NSURL, NSNull>()
  
  var customUrlSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = TimeInterval(10)
    configuration.timeoutIntervalForResource = TimeInterval(10)
    return URLSession(configuration: configuration)
  }()
}

enum FetchStatus {
  case loaded, loading, hasCache
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
  

}

