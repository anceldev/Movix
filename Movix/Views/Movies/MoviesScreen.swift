//
//  MoviesScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct MoviesScreen: View {
//    @State private var query = ""
//    @State private var debouncedQuery = ""
    let query: String
    @State private var showFilterSheet = false
    @State private var viewOption: ViewOption = .gridx3
//    @State var moviesVM = MoviesViewModel()
    @Environment(MoviesViewModel.self) var moviesVM
    
    @State var results = [Movie]()

    @Environment(NavigationManager.self) var navigationManager
    @Environment(UserViewModel.self) var userVM
    var body: some View {
        VStack {
            VStack(spacing: 16) {
//                SearchBarView(
//                    title: NSLocalizedString("movies-tab-label", comment: "movies screen"),
//                    query: $query,
//                    debounceQuery: $debouncedQuery,
//                    showFilterSheet: $showFilterSheet,
//                    viewOption: $viewOption
//                )
                VStack {
                    ScrollView(.vertical) {
                        GridItemsView<Movie>(
                            mediaItems: query.isEmpty ? moviesVM.trending : moviesVM.movies,
                            mediaType: .movie,
                            viewOption: viewOption
                        )
//                        VStack {
//                            Button {
//                                search(query: debouncedQuery)
//                            } label: {
//                                Image(systemName: "chevron.down")
//                                    .foregroundStyle(.white)
//                            }
//                        }
//                        .padding(.top, 8)
//                        .padding(.bottom, 16)
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
            FilteredSearchScreen<Movie>(results: $results, mediaType: .movie)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
//        .onChange(of: debouncedQuery) { _, newValue in
//            search(query: newValue)
//        }
        .environment(navigationManager)
        .enableInjection()
    }
//    private func search(query: String) {
//        Task {
//            if query != "" {
//                await moviesVM.searchMovies(searchTerm: debouncedQuery)
//            } else {
//                await moviesVM.loadTrending()
//            }
//        }
//    }
}

#Preview {
    MoviesScreen(query: "")
        .environment(UserViewModel(user: PreviewData.user))
        .environment(NavigationManager())
}
