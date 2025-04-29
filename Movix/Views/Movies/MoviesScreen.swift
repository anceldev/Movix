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
    //    @Environment(MoviesViewModel.self) var moviesVM
    @State var moviesVM = MoviesViewModel()
    @Environment(NavigationManager.self) var navigationManager
    @Environment(UserViewModel.self) var userVM
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("movies-tab-label")
                        .font(.hauora(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                    HStack(spacing: 16) {
                        SearchField(query: $query, debounceQuery: $debounceQuery)
                            .padding(.leading)
                        SearchBarButtons(showFilterSheet: $showFilterSheet, viewOption: $viewOption)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                }
                VStack {
                    GridItemsView<Movie>(
                        mediaItems: debounceQuery.isEmpty ? moviesVM.trending : moviesVM.movies,
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
            .environment(userVM)
        }
        .withAppRouter()
        .animation(.easeIn, value: viewOption)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showFilterSheet) {
            Text("Filter screen")
        }
        .onChange(of: debounceQuery) { _, newValue in
            search(query: newValue)
        }
        .environment(navigationManager)
    }
    private func search(query: String) {
        Task {
            if query != "" {
                await moviesVM.searchMovies(searchTerm: debounceQuery)
            } else {
                await moviesVM.loadTrending()
            }
        }
    }
}

#Preview {
    MoviesScreen()
    //        .environment(NavigationManager())
}
