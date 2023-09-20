//
//  Lowkey_Pexels_API_Test_taskApp.swift
//  Lowkey Pexels API Test task
//
//  Created by Andrei Dobysh on 15.09.23.
//

import SwiftUI

@main
struct Lowkey_Pexels_API_Test_taskApp: App {
  
  init() {
    /// Cache setup
    URLCache.shared.memoryCapacity = 50_000_000 // ~50 MB
    URLCache.shared.diskCapacity = 100_000_000 // ~100 MB
  }
  
  var body: some Scene {
    WindowGroup {
      HomeView()
    }
  }
}
