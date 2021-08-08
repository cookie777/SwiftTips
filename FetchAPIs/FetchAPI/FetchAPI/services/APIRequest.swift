//
//  APIRequset.swift
//  APIFetching
//
//  Created by Takayuki Yamaguchi on 2021-08-01.
//

import UIKit

class APIRequest {
  static let shared = APIRequest()
  private init() { }
  private var dataTask: URLSessionDataTask?
  
  let imageCache = NSCache<NSURL, UIImage>()
  let requestCache = NSCache<NSURL, ImageRequest>()
  
  var customUrlSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = TimeInterval(300)
    configuration.timeoutIntervalForResource = TimeInterval(300)
    return URLSession(configuration: configuration)
  }()
}

enum FetchStatus {
  case loaded, loading, hasCache
}
class ImageRequest {
  var completion: (UIImage?, FetchStatus) -> Void
  init(_ completion: @escaping (UIImage?, FetchStatus) -> Void){
    self.completion = completion
  }
}



// MARK: - Basic fetch

extension APIRequest {
  
  /// Fetch json type
  /// - Parameters:
  ///   - url: end point
  ///   - completion: handling parsed Json
  private func fetch<T: Decodable>(from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
    dataTask?.cancel()
    
    dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      // client error
      guard error == nil else {
        completion(.failure(.client(message: error!.localizedDescription)))
        return
      }
      
      // server error
      guard let res = response as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
        completion(.failure(.server))
        return
      }
      
      do {
        guard let data = data else {
          // data is nil
          completion(.failure(.client(message: error!.localizedDescription)))
          return
        }
        let decodable = try JSONDecoder().decode(T.self, from: data)
        completion(.success(decodable))
      } catch {
        // decode error
        completion(.failure(.client(message: error.localizedDescription)))
      }
    }
    
    dataTask?.resume()
  }
  
  /// Fetch image
  /// - Parameters:
  ///   - url: end point
  ///   - completion: handle fetched image
  private func fetchImage(from url: URL, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
    
    customUrlSession.dataTask(with: url) { (data, response, error) in
      // client error
      guard error == nil else {
        completion(.failure(.client(message: error!.localizedDescription)))
        return
      }
      
      // server error
      guard let res = response as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
        completion(.failure(.server))
        return
      }
      
      // data is nil
      guard let data = data, let image = UIImage(data: data) else {
        completion(.failure(.client(message: "data error")))
        return
      }
      completion(.success(image))
    }.resume()
    
  }
  
}


// MARK: - Headings

extension APIRequest {
  
  /// Fetch all `People objects`
  /// - Parameter completion: handle `[People]`
  func fetchAllItems(completion: @escaping ([People])->Void) {
    APIRequest.shared.fetch(from: URL(string: "https://rickandmortyapi.com/api/character")!)
    { (result: Result<Peoples, NetworkError>) in
      
      switch result {
        case .success(let data):
          completion(data.results)
        case .failure(let error):
          debugPrint(error.localizedDescription)
      }
      
    }
  }
  
  /// Fetch a detail of people
  /// - Parameters:
  ///   - id: target id
  ///   - completion: handle fetched detail
  func fetchItem(id: Int, completion: @escaping (PeopleDetail)->Void) {
    APIRequest.shared.fetch(from: URL(string: "https://rickandmortyapi.com/api/character/\(id)")!)
    { (result: Result<PeopleDetail, NetworkError>) in
      
      switch result {
        case .success(let data):
          completion(data)
        case .failure(let error):
          debugPrint(error.localizedDescription)
      }
      
    }
  }
  
  /// Fetch image
  /// - Parameters:
  ///   - url: target url
  ///   - completion: handle fetched iamge
  func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
    
    APIRequest.shared.fetchImage(from: url)
    {  (result: Result<UIImage?, NetworkError>) in
      
      switch result {
        case .success(let image):
          completion(image)
          
        case .failure(let error):
          completion(nil)
          debugPrint(error.localizedDescription)
      }
      
    }
  }
}
