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
    
    
    private var list = ["Monday", "Tuesday", "Wednesday"]
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        VStack {
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
                                        })
                                    )
                                    //.environmentObject(movieViewModel)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .background(.blackApp)
                    .scrollContentBackground(.hidden)
                }
                .scrollIndicators(.hidden)
            }
            //.navigationViewStyle(.stack)
            .searchable(text: $queryText, prompt: "Search...")
            .foregroundStyle(.blackWhite)
            .onChange(of: queryText) {
                movieViewModel.getMovies(withQuery: queryText)
            }
        }
        .onAppear(perform: {
            movieViewModel.getTrending()
        })
    }
}

#Preview {
    SearchView()
}
