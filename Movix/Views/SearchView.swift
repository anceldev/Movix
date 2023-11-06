//
//  SearchView.swift
//  Movix
//
//  Created by Ancel Dev account on 1/11/23.
//

import SwiftUI

struct SearchView: View {
    
    @State private var queryText = ""
    @StateObject var movieViewModel = MovieViewModel()
    
    var body: some View {
        //VStack {
            NavigationView {
                VStack {
                    List {
                        if !movieViewModel.movies.isEmpty {
                            ForEach(movieViewModel.movies) { movie in
                                MovieResult(movie: movie, urlImage: movieViewModel.urlImageMovie(urlBackdrop: movie.backdropPath ?? ""))
                                    .listRowInsets(EdgeInsets())
                                    .background(
                                        NavigationLink("", destination: {
                                            MovieDetails(idMovie: movie.id)
                                                .environmentObject(movieViewModel)
                                            
                                        }))
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .background(.blackApp)
            }
            .searchable(text: $queryText, prompt: "Search...")
            .foregroundStyle(.blackWhite)
            .onChange(of: queryText) {
                movieViewModel.getMovies(withQuery: queryText)
            }
            .foregroundStyle(.blackWhite)
            .onAppear(perform: {
                if queryText.isEmpty {
                    movieViewModel.getTrending()
                }
            })
            
        /*}
        .foregroundStyle(.blackWhite)
        .onAppear(perform: {
            if queryText.isEmpty {
                movieViewModel.getTrending()
            }
        })*/
    }
}

#Preview {
    SearchView()
}
