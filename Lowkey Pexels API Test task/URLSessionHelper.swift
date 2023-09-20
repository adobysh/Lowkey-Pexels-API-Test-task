//
//  URLSessionHelper.swift
//  Lowkey Pexels API Test task
//
//  Created by Andrei Dobysh on 20.09.23.
//

import Foundation

enum FetchError: Error {
  case badURL(url: String?)
  case badURLWithGETParams(url: String?)
  case resultIsNil(url: String?)
}

extension FetchError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .badURL:
      return "badURL"
    case .badURLWithGETParams:
      return "badURLWithGETParams"
    case .resultIsNil:
      return "resultIsNil"
    }
  }
}

class URLSessionHelper {
  
  static let shared = URLSessionHelper()
  
  private let API_KEY = "8zVpQDC8hIWUenYJsnMbwVOT9zusJttLOZSz1xO45rHkwLWArpSW2Etw"
  
  private lazy var requiredHeaders: [String: String] = [
    "Authorization" : API_KEY
  ]
  
  private init() {}
  
  // MARK: - Public Methods
  func request<A: APIProtocol>(api: A,
                               completion: @escaping (Result<A.T, Error>)->Void) {
    request(api.link,
            httpMethod: api.method.rawValue,
            resultType: A.T.self) { result in
      completion(result)
    }
  }
  
  func request<T: Decodable & APIDataProtocol>(
    _ urlAsText: String,
    httpMethod: String,
    resultType: T.Type) async throws -> T {
      try await withCheckedThrowingContinuation { continuation in
        request(urlAsText,
                httpMethod: httpMethod,
                resultType: resultType) { result in
          continuation.resume(with: result)
        }
      }
    }
  
  /// Method for performing network requests with closure.
  /// Note: this is a wrapper of async/await method for logs in one place and for usage with closure.
  func request<T: Decodable & APIDataProtocol>(
    _ urlAsText: String,
    httpMethod: String,
    resultType: T.Type,
    completion: @escaping (Result<T, Error>)->Void) {
      
      /// An important print to show all request's details.
      print("[request: \(urlAsText), httpMethod: \(httpMethod), resultType<?>: \(T.self)]")
      
      Task {
        do {
          let (data, response) = try await request(
            urlAsText,
            httpMethod: httpMethod,
            resultType: T.self)
          
          /// An important print to show all request's responses.
          print("[response: \(response), \ndata: \(data)]")
          
          await MainActor.run {
            completion(.success(data))
          }
        } catch {
          /// An important print to show all request's errors.
          print("[response: REQUEST FAILED, check the error below]")
          print("[error: \(error)]")
          
          await MainActor.run {
            completion(.failure(error))
          }
        }
      }
    }
  
  // MARK: - Private Methods
  
  /// The only method that actually doing API requests with URLSession.
  private func request<T: Decodable & APIDataProtocol>(
    _ link: String,
    httpMethod: String,
    resultType: T.Type) async throws -> (result: T, response: URLResponse) {
      guard var components = URLComponents(string: "\(link)") else { throw FetchError.badURL(url: link) }
      
      /// Apple's recommendation
      /// https://stackoverflow.com/questions/27723912/swift-get-request-with-parameters
      components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
      
      guard let url = components.url else { throw FetchError.badURLWithGETParams(url: link) }
      
      var request = URLRequest(url: url)
      request.httpMethod = httpMethod
      
      /// Adding Headers.
      for (key, value) in requiredHeaders {
        request.setValue(value, forHTTPHeaderField: key)
      }
      
      let (data, response) = try await URLSession.shared.data(for: request)
      let jsonDecoder = JSONDecoder()
      jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
      guard let result = try jsonDecoder.decode(T?.self, from: data) else {
        throw FetchError.resultIsNil(url: link)
      }
      return (result, response)
    }
}
