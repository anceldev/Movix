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
    
    enum MovieActionsButtons: CaseIterable {
        case rate
        case download
        case heart
        case invite
        
        var image: Image {
            switch self {
            case .rate: return Image("rate")
            case .download: return Image("download")
            case .heart: return Image("heart")
            case .invite: return Image("inviteFriend")
            }
        }
        var title: String {
            switch self {
            case .rate: return "Rate"
            case .download: return "Download"
            case .heart: return "Like"
            case .invite: return "Invite"
            }
        }
    }
    @State private var backdropUrl = ""
    @State private var posterUrl = ""
    
    func fetchMovie(){
        Task {
            do {
                let newMovie = try await MediaService.service.searchDetails(movie: self.idMovie)
                self.searchedMovie = Movie(origin: newMovie)
                if let backdrop = searchedMovie?.backdropPath {
                    backdropUrl = "https://image.tmdb.org/t/p/w780/" + backdrop
                }
                if let poster = searchedMovie?.posterPath {
                    posterUrl = "https://image.tmdb.org/t/p/w500/" + poster
                }
            }
            catch {
                throw error
            }
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    let size = geometry.size
                    ZStack {
//                        AsyncImage(url: URL(string: backdropUrl)) { image in
//                            image
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: size.width , height: size.height)
//                                .overlay {
//                                    LinearGradient(
//                                        colors: [.blackApp.opacity(0.59), .clear, .blackApp.opacity(1     )],
//                                        startPoint: .top,
//                                        endPoint: .bottom)
//                                }
//                        } placeholder: {
//                            ProgressView()
//                        }
                        AsyncImage(url: URL(string: posterUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxHeight: size.height)
                        LinearGradient(
                            colors: [.blackApp.opacity(0.59), .clear ,.blackApp.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    }
                }
            }
            .frame(height: 568)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.semiWhite)
            VStack {
                VStack {
                    MovieBarButtons()
                        .padding(15)
                }
                VStack {
                    Text(searchedMovie?.overview ?? "No overview")
                        .lineLimit(3)
                        .foregroundStyle(.semiWhite)
                }
                .padding(.horizontal, 20)
                Spacer()
            }
            .background(.blackApp)
        }
        .ignoresSafeArea()
        .background(.blackApp)
        .onAppear(perform: {
            fetchMovie()
        })
    }
    @ViewBuilder
    func MovieBarButtons() -> some View {
        HStack(spacing: 20) {
            ForEach(MovieActionsButtons.allCases, id:\.self) { btn in
                Button {
                    print(btn.title)
                } label: {
                    VStack{
                        btn.image
                        Text(btn.title)
                            .font(.footnote)
                    }
                }
                .frame(minWidth: 62, maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 40)
        .font(.largeTitle)
        .foregroundStyle(.grayLight)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    MovieDetails(idMovie: 872585)
//        .environmentObject(MovieViewModel())
}
