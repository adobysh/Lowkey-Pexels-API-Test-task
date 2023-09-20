//
//  RoundedCorner.swift
//  Lowkey Pexels API Test task
//
//  Created by Andrei Dobysh on 20.09.23.
//

import SwiftUI

struct RoundedCorner: Shape {
  
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}
