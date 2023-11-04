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
    @State var movie: Movie?
    
    @State var tabButton: Bool? = true
    var body: some View {
        VStack{
            ZStack{
                AsyncImage(
                    url: movie?.imageUrl,
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 400)
                    }) {
                        ProgressView()
                    }
                VStack{
                    Spacer()
                    VStack {
                        HStack(spacing: 20){
                            Text("GB")
                            Text("Drama")
                            Text("History")
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
            .frame(maxHeight: 400)
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
        .background(.secondBlack)
        .ignoresSafeArea()
        .onAppear{
            self.movie = viewModel.getDetails(forMovie: idMovie)
        }
    }
}

#Preview {
    MovieDetails(idMovie: 872585)
        .environmentObject(MovieViewModel())
}
