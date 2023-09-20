//
//  HomeView.swift
//  Lowkey Pexels API Test task
//
//  Created by Andrei Dobysh on 15.09.23.
//

import SwiftUI

struct CuratedPhoto: Identifiable, Hashable {
  init(apiModel: CuratedPhotoAPIModel) {
    photographerName = apiModel.photographer
    smallPhotoLink = apiModel.src?.large2x
    originalPhotoLink = apiModel.src?.original
    width = apiModel.width
    height = apiModel.height
  }
  
  var id = UUID()
  var photographerName: String?
  var smallPhotoLink: String?
  var originalPhotoLink: String?
  var width: Int?
  var height: Int?
}

struct HomeView: View {
  @State var errorMessage: String? = nil
  @State var isShowingErrorAlert: Bool = false
  @State var detailsModel: DetailsModel?
  
  @State var collection: [CuratedPhoto] = []
  @State var customUrl: String? = nil
  
  var body: some View {
    VStack {
      Text("Pexels")
        .bold()
        .padding()
      List {
        ForEach(collection.enumerated().map({ $0 }), id: \.element.id, content: { index, element in
          HomeCellView(name: element.photographerName, imageURL: URL(string: element.smallPhotoLink ?? ""), width: element.width, height: element.height)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .onAppear {
              if index >= collection.count - 1 && customUrl != nil {
                loadData()
              }
            }
            .onTapGesture {
              detailsModel = DetailsModel(url: URL(string: element.originalPhotoLink ?? ""))
            }
        })
      }
      .listStyle(PlainListStyle())
      .refreshable {
        customUrl = nil
        collection = []
        loadData()
      }
    }
    .alert(
      Text(errorMessage ?? ""),
      isPresented: $isShowingErrorAlert,
      presenting: errorMessage
    ) { details in
      Button("OK") { }
    }
    .sheet(item: $detailsModel, content: { detailsModel in
      DetailsView(model: detailsModel)
    })
    .onAppear {
      loadData()
    }
  }
  
  func loadData() {
    let api = CuratedPhotosAPI(customLink: customUrl)
    URLSessionHelper.shared.request(api: api) { result in
      switch result {
      case .success(let data):
        customUrl = data.nextPage
        let nextPageUICollection = (data.photos ?? []).map { CuratedPhoto(apiModel: $0) }
        collection.append(contentsOf: nextPageUICollection)
      case .failure(let error):
        errorMessage = "\(error)"
        isShowingErrorAlert = true
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}

struct HomeCellView: View {
  @State var name: String?
  @State var imageURL: URL?
  @State var width: Int?
  @State var height: Int?
  
  var body: some View {
    ZStack {
      Color.white
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .inset(by: 0.5)
            .stroke(Color(red: 1, green: 1, blue: 1), lineWidth: 1)
        )
      VStack(spacing: 0) {
        AsyncImage(url: imageURL) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          ZStack {
            Color.white
              .aspectRatio(CGSize(width: width ?? 1, height: height ?? 1), contentMode: .fit)
            ProgressView()
          }
        }
        .cornerRadius(8, corners: [.topLeft, .topRight])
        Text(name ?? "")
          .italic()
          .bold()
          .padding()
      }
    }
  }
}
