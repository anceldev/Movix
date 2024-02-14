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
    
    var body: some View {
        NavigationView {
            NavigationStack(path: $path) {
                VStack {
//                    HStack{
//                        Button(action: {
//                            // All
//                            print("All tapped")
//                        }, label: {
//                            Text("All")
//                        })
//                        .frame(maxWidth: .infinity)
//                        Button(action: {
//                            // Movies
//                            print("Movies tapped")
//                        }, label: {
//                            Text("Movies")
//                        })
//                        .frame(maxWidth: .infinity)
//                        Button(action: {
//                            // Series
//                            print("Series tapped")
//                        }, label: {
//                            Text("Series")
//                        })
//                        .frame(maxWidth: .infinity)
//                    }
                    List {
                        ForEach(movies, id:\.id) { movie in
                            NavigationLink(value: movie.id) {
                                Text(movie.title!)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .onChange(of: queryText, {
                        getMoviesList()
                    })
                }
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
        .searchable(text: $queryText)
    }
    
    private func getMoviesList(){
        print("Searching: " + queryText)
        Task {
            do {
                if let movies = try await MediaService.service.searchMedia(query: queryText) as? [Movie] {
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
    HomeView()
}
