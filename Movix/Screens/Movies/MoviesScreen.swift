//
//  MoviesScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct MoviesScreen: View {
    @State private var searchTerm = ""
    @State private var showFilterSheet = false
    @State private var viewOption: ViewOption = .gridx3
    @Environment(MoviesViewModel.self) var moviesVM
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Movies")
                            .font(.hauora(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                        HStack(spacing: 16) {
                            SearchField(
                                searchTerm: $searchTerm,
                                loadAction: loadMovies){
                                    moviesVM.searchedMovies.removeAll()
                                }
                                .padding(.leading)
                            SearchBarButtons(showFilterSheet: $showFilterSheet, viewOption: $viewOption)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                    }
                    Group {
                        switch viewOption {
                        case .row:
                            MediaRowLayout<Movie>(
                                mediaItems: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
                                mediaType: .movie
                            )
                        case .gridx2:
                            GridItemsView<Movie>(
                                mediaItems: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
                                searchTerm: .constant(""),
                                mediaType: .movie,
                                columns: [GridItem(.flexible()), GridItem(.flexible())]
                            )
                        case .gridx3:
                            GridItemsView<Movie>(
                                mediaItems: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
                                searchTerm: .constant(""),
                                mediaType: .movie,
                                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                            )
                        }
                    }
                    .padding(.horizontal)
                    VStack {
                        Button {
                            loadMovies()
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.bw10)
            }
            .toolbarBackground(.clear, for: .navigationBar)
        }
        .animation(.easeIn, value: viewOption)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showFilterSheet) {
            Text("Filter screen")
        }
    }
    private func loadMovies() {
        Task {
            if searchTerm.isEmpty {
                await moviesVM.getTrendingMovies()
            }
            else {
                await moviesVM.searchMovies(searchTerm: searchTerm)
            }
        }
    }
}

