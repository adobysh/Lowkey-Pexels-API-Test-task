//
//  APIProtocol.swift
//  Lowkey Pexels API Test task
//
//  Created by Andrei Dobysh on 20.09.23.
//

import Foundation

enum APIMethod: String {
  case GET
}

enum APIAccept: String {
  case text_html = "text/html"
}

protocol APIDataProtocol: Codable, Equatable {
  
}

protocol APIProtocol {
  associatedtype T: Decodable & APIDataProtocol
  
  var method: APIMethod { get }
  
  var link: String { get }
  
  func resultType<T: Decodable>() -> T.Type
}

extension APIProtocol {
  func resultType<T>() -> T.Type where T : Decodable {
    return T.self
  }
}
