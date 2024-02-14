//
//  HomeView.swift
//  Movix
//
//  Created by Ancel Dev account on 25/10/23.
//

import SwiftUI
import UIKit
struct HomeView: View {
    
    @State var queryText = ""
    @State var movies = [Movie]()
    @State var path = NavigationPath()
    
    @State private var filter = MediaFilter.movie
    
    var body: some View {
        NavigationView {
            NavigationStack(path: $path) {
                VStack {
                    HStack{
                        Button(action: {
                            // All
                            print("All tapped")
                        }, label: {
                            Text("All")
                        })
                        .frame(maxWidth: .infinity)
                        Button(action: {
                            // Movies
                            print("Movies tapped")
                            filter = .movie
                        }, label: {
                            Text("Movies")
                        })
                        .frame(maxWidth: .infinity)
                        Button(action: {
                            // Series
                            print("Series tapped")
                            filter = .tv
                        }, label: {
                            Text("Series")
                        })
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 10)
                    Spacer()
                    ScrollView {
                        LazyVStack {
                            ForEach(movies, id:\.id) { movie in
                                NavigationLink(value: movie.id) {
                                    MovieRow(movie: movie)
                                }
                            }
                            .onChange(of: queryText, {
                                getMoviesList()
                            })
                        }
                        .ignoresSafeArea(.container, edges: .top)
                        .navigationDestination(for: Int.self) { id in
                            MovieDetails(idMovie: id)
                            //                    TestView(id: id)
                        }
                        .background(.blackApp)
                        .navigationTitle("Catalog")
                        .navigationBarTitleDisplayMode(.inline)
                        .foregroundStyle(.semiWhite)
                    }
                }
                .background(.blackApp)
            }
            
        }
        .searchable(text: $queryText)
        
    }
    @ViewBuilder
    func MovieRow(movie: Movie) -> some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500" + (movie.backdropPath ?? "no backdrop"))) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                } placeholder: {
                    ProgressView()
                }
                
            }
            .frame(width: 200)
            VStack {
                HStack {
                    Text(movie.title ?? "-- No  title --")
                        .hauroaBold()
                        .padding(.top, 10)
                        .multilineTextAlignment(.leading)
                }
                .padding(5)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func getMoviesList(){
        print("Searching: " + queryText)
        Task {
            do {
                if let movies = try await MediaService.service.searchMedia(query: queryText, filter: filter) as? [Movie] {
                    self.movies = movies
                    print(movies.count)
                }
            }
            catch {
                print("Error fetching movies")
            }
        }
    }
}

#Preview {
    HomeView(queryText: "Guardians of the galaxy")
}
