//
//  MovieDetails.swift
//  Movix
//
//  Created by Ancel Dev account on 23/10/23.
//

import SwiftUI

struct MovieDetails: View {
    @EnvironmentObject var viewModel: MovieViewModel
    var idMovie: Int
        
    @State var tabButton: Bool? = true
    
    var body: some View {
        VStack{
            ZStack{
                AsyncImage(
                    url: viewModel.getPosterUrl(urlPoster: viewModel.movie.posterPath ?? ""),
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 600)
                            
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
            .frame(height: 468)
            VStack{
                VStack{
                    //Text(movie?.overview ?? "")
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
        .background(.secondBlack)
        .ignoresSafeArea()
        .onAppear{
            viewModel.getDetails(forMovie: idMovie)
        }
    }
}

#Preview {
    MovieDetails(idMovie: 872585)
        .environmentObject(MovieViewModel())
}
