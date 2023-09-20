//
//  DetailsView.swift
//  Lowkey Pexels API Test task
//
//  Created by Andrei Dobysh on 20.09.23.
//

import SwiftUI

struct DetailsModel: Identifiable {
  var id = UUID()
  var url: URL?
}

struct DetailsView: View {
  
  @State var model: DetailsModel?
  
  var body: some View {
    AsyncImage(url: model?.url) { image in
      image
        .resizable()
        .scaledToFit()
    } placeholder: {
      ProgressView()
        .frame(maxWidth: .infinity)
    }
  }
}

struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    DetailsView(model: DetailsModel())
  }
}
