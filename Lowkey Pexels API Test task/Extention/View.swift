//
//  View.swift
//  Lowkey Pexels API Test task
//
//  Created by Andrei Dobysh on 20.09.23.
//

import SwiftUI

extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape( RoundedCorner(radius: radius, corners: corners) )
  }
}
