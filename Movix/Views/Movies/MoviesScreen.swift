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
    @State private var debouncedQuery = ""
    @State private var showFilterSheet = false
    @State private var viewOption: ViewOption = .gridx3
    @State var moviesVM = MoviesViewModel()

    @Environment(NavigationManager.self) var navigationManager
    @Environment(UserViewModel.self) var userVM
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                SearchBarView(
                    title: NSLocalizedString("movies-tab-label", comment: "movies screen"),
                    query: $query,
                    debounceQuery: $debouncedQuery,
                    showFilterSheet: $showFilterSheet,
                    viewOption: $viewOption
                )
                VStack {
                    ScrollView(.vertical) {
                        GridItemsView<Movie>(
                            mediaItems: debouncedQuery.isEmpty ? moviesVM.trending : moviesVM.movies,
                            mediaType: .movie,
                            viewOption: viewOption
                        )
                        VStack {
                            Button {
                                search(query: debouncedQuery)
                            } label: {
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    }
                    .scrollIndicators(.hidden)
                }
                .padding(.horizontal)
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
        .onChange(of: debouncedQuery) { _, newValue in
            search(query: newValue)
        }
        .environment(navigationManager)
    }
    private func search(query: String) {
        Task {
            if query != "" {
                await moviesVM.searchMovies(searchTerm: debouncedQuery)
            } else {
                await moviesVM.loadTrending()
            }
        }
    }
}

#Preview {
    MoviesScreen()
        .environment(UserViewModel(user: PreviewData.user))
        .environment(NavigationManager())
}
