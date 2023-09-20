//
//  CuratedPhotosAPI.swift
//  Lowkey Pexels API Test task
//
//  Created by Andrei Dobysh on 17.09.23.
//

import Foundation

struct CuratedPhotosAPIModel: APIDataProtocol {
  var page: Int?
  var perPage: Int?
  var photos: [CuratedPhotoAPIModel]?
  var nextPage: String?
}

struct CuratedPhotoAPIModel: Codable, Equatable {
  var id: Int?
  var width: Int?
  var height: Int?
  var url: String?
  var photographer: String?
  var photographerUrl: String?
  var photographerId: Int?
  var avgColor: String?
  var src: CuratedPhotoSrc?
  var liked: Bool?
  var alt: String?
}

struct CuratedPhotoSrc: Codable, Equatable {
  var original: String?
  var large2x: String?
  var large: String?
  var medium: String?
  var small: String?
  var portrait: String?
  var landscape: String?
  var tiny: String?
}

struct CuratedPhotosAPI: APIProtocol {
  typealias T = CuratedPhotosAPIModel
  
  var customLink: String? = nil
  
  var method: APIMethod = .GET
  
  var link: String {
    return customLink ?? "https://api.pexels.com/v1/curated"
  }
}
