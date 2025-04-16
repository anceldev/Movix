//
//  MoviesScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

enum MediaNavigation: Equatable {
    case movie
    case tv
}

struct MoviesScreen: View {
    @State private var query = ""
    @State private var debounceQuery = ""
    
    @State private var showFilterSheet = false
    @State private var viewOption: ViewOption = .gridx3
    @Environment(MoviesViewModel.self) var moviesVM
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        @Bindable var routerDestination = navigationManager
        VStack {
            NavigationStack(path: $routerDestination.path) {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("movies-tab-label")
                            .font(.hauora(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                        HStack(spacing: 16) {
                            SearchField(searchTerm: $query, debounceQuery: $debounceQuery)
                            SearchBarButtons(showFilterSheet: $showFilterSheet, viewOption: $viewOption)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                    }
//                    Group {
//                        switch viewOption {
//                        case .gridx2:
//                            GridItemsView<Movie>(
//                                mediaItems: debounceQuery.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
//                                searchTerm: .constant(""),
//                                mediaType: .movie,
//                                columns: [GridItem(.flexible()), GridItem(.flexible())]
//                            )
//                        case .gridx3:
//                            GridItemsView<Movie>(
//                                mediaItems: debounceQuery.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
//                                searchTerm: .constant(""),
//                                mediaType: .movie,
//                                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
//                            )
//                        }
//                    }
//                    .padding(.horizontal)
                    VStack {
                        GridItemsView<Movie>(
                            mediaItems: debounceQuery.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
                            mediaType: .movie,
                            columns: viewOption == .gridx2 ? 2 : 3
                        )
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Button {
                            search(query: debounceQuery)
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.bw10)
                .withAppRouter()
            }
        }
        .animation(.easeIn, value: viewOption)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showFilterSheet) {
            Text("Filter screen")
        }
        .onChange(of: debounceQuery) { _, newValue in
            search(query: newValue)
        }
    }
    private func search(query: String) {
        Task {
        
        }
    }
}

