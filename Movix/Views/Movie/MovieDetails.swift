//
//  MovieDetails.swift
//  Movix
//
//  Created by Ancel Dev account on 23/10/23.
//

import SwiftUI

struct MovieDetails: View {
    let idMovie: Int
    @State var searchedMovie: Movie?
    
    //    init(idMovie: Int) {
    //        self.idMovie = idMovie
    //    }
    
    func fetchMovie(){
        Task {
            do {
                let newMovie = try await MediaService.service.searchDetails(movie: self.idMovie)
                self.searchedMovie = Movie(origin: newMovie)
            }
            catch {
                throw error
            }
        }
    }
    var body: some View {
        VStack {
            if searchedMovie != nil {
                Text("Id is: \(idMovie)")
                Text(searchedMovie?.title ?? "No title available")
                Text(searchedMovie?.overview ?? "No overview available")
            }
        }
        .onAppear(perform: {
            fetchMovie()
        })
    }
}


//    var body: some View {
//        VStack {
//            VStack(spacing: 0){
//                GeometryReader(content: { geometry in
//                    let size = geometry.size
//                    VStack {
//                        AsyncImage(
//                            url: viewModel.getPosterUrl(urlPoster: viewModel.movie.posterPath ?? ""),
//                            content: { image in
//                                PosterView(poster: image, size: size)
//                            }) {
//                                ProgressView()
//                            }
//                            .frame(maxWidth: size.width, maxHeight: 468)
//                    }
//                })
//            }
//            .frame(maxHeight: 468)
//            VStack {
//                NavigationStack {
//                    VStack{
//                        VStack{
//                            HStack(spacing: 20) {
//Spacer()
//                                Button(action: {
// rate
//                                }, label: {
//                                    VStack {
//                                        Image("rate")
//                                        Text("Rate")
//                                            .font(.footnote)
//                                    }
//                                })
//                                .frame(minWidth: 62, maxWidth: .infinity)
//                                Button(action: {
// Download
//                                }, label: {
//                                    VStack {
//                                        Image("download")
//                                        Text("Download")
//                                            .font(.footnote)
//                                    }
//                                })
//                                .frame(minWidth: 62, maxWidth: .infinity)
//                                Button(action: {
// Download
//                                }, label: {
//                                    VStack {
//                                        Image("heart")
//                                        Text("My list")
//                                            .font(.footnote)
//                                    }
//
//                                })
//                                .frame(minWidth: 62, maxWidth: .infinity)
//                                Button(action: {
// Download
//                                }, label: {
//                                    VStack {
//                                        Image("inviteFriend")
//                                        Text("Live")
//                                            .font(.footnote)
//                                    }
//                                })
//                                .frame(minWidth: 62, maxWidth: .infinity)
//Spacer()
//                            }
//                            .font(.largeTitle)
//                            .foregroundStyle(.textGray)
//                            .multilineTextAlignment(.center)
//                            .frame(maxWidth: 261, minHeight: 60)
//                            VStack{
//                                Text(viewModel.movie.overview ?? "")
//                                    .font(.body)
//                                    .padding(15)
//                            }
//                            .foregroundColor(.white)
//                            HStack(spacing: 25){
//                                Button {
//                                    tabButton = true
//                                } label: {
//                                    Text("General")
//                                        .foregroundStyle(tabButton == true ? .white : .textGray)
//                                }
//                                Button {
//                                    tabButton = false
//                                } label: {
//                                    Text("Details")
//                                        .foregroundStyle(tabButton == false ? .white : .textGray)
//                                }
//                                Button {
//                                    tabButton = nil
//                                } label: {
//                                    Text("Comments")
//                                        .foregroundStyle(tabButton == nil ? .white : .textGray)
//                                }
//                            }
//                            .multilineTextAlignment(.center)
//                            .font(.title2)

//                            VStack{
/*if tabButton == true {
 MovieGeneralTab(movie: movie!)
 } else if tabButton == false {
 MovieDetailTab()
 } else {
 MovieCommentsTab()
 }*/
//                            }
//                        }
//                        .padding(.top, 16)
//                        Spacer()
//                    }
//
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blackApp.ignoresSafeArea())
//                    .ignoresSafeArea()
//                    .task {
//                        viewModel.getDetails(forMovie: idMovie)
//                    }
//                }
//            }
//        }
//        .task {
//            viewModel.getDetails(forMovie: idMovie)
//        }
//        .background(.blackApp)
//        .ignoresSafeArea()
/*NavigationStack {
 VStack{
 VStack {
 ZStack{
 AsyncImage(
 url: viewModel.getPosterUrl(urlPoster: viewModel.movie.posterPath ?? ""),
 content: { image in
 image
 .resizable()
 .aspectRatio(contentMode: .fit)
 .frame(maxWidth: .infinity, maxHeight: 700)
 .clipped()
 .overlay {
 LinearGradient(colors: [
 .clear,
 .clear,
 .clear,
 .black.opacity(0.1),
 .black.opacity(0.5),
 .black.opacity(0.9),
 .black
 ], startPoint: .top, endPoint: .bottom)
 }
 }) {
 ProgressView()
 }
 VStack{
 Spacer()
 VStack {
 HStack(spacing: 20){
 Text(viewModel.makeTags())
 }
 .padding(.bottom, 4)
 HStack {
 Text("2023")
 Text(" | ")
 Text("3h1min")
 Text(" | ")
 Text("18+")
 }
 .font(.footnote).bold()
 .padding(.bottom, 7)
 }
 }
 .foregroundStyle(.white)
 
 }
 Spacer()
 }
 .ignoresSafeArea()
 
 
 .frame(height: 468)
 
 VStack{
 VStack{
 Text(movie?.overview ?? "")
 }
 .padding()
 .foregroundColor(.white)
 HStack(spacing: 25){
 Button {
 tabButton = true
 } label: {
 Text("General")
 .foregroundStyle(tabButton == true ? .white : .textGray)
 }
 Button {
 tabButton = false
 } label: {
 Text("Details")
 .foregroundStyle(tabButton == false ? .white : .textGray)
 }
 Button {
 tabButton = nil
 } label: {
 Text("Comments")
 .foregroundStyle(tabButton == nil ? .white : .textGray)
 }
 }
 .multilineTextAlignment(.center)
 .font(.title2)
 .padding(.top)
 VStack{
 /*if tabButton == true {
  MovieGeneralTab(movie: movie!)
  } else if tabButton == false {
  MovieDetailTab()
  } else {
  MovieCommentsTab()
  }*/
 }
 }
 Spacer()
 }
 
 .frame(maxWidth: .infinity)
 .background(Color.blackApp.ignoresSafeArea())
 .ignoresSafeArea()
 .task {
 viewModel.getDetails(forMovie: idMovie)
 }
 }*/
//        .background(.blackApp)
//    }
//}
//
//#Preview {
//    MovieDetails(idMovie: 872585)
//        .environmentObject(MovieViewModel())
//}
