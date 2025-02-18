//
//  ItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ItemsView: View {
    enum FetchAction {
        case trending
        case search
        case favMovies
    }
    @Environment(MoviesViewModel.self) var moviesVM

    @Binding var searchTerm: String
    let itemsView: ViewOption
    
    var body: some View {
        @Bindable var moviesVM = moviesVM
        ScrollView(.vertical) {
                switch itemsView {
                case .row:
                    ListItemsView(movies: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies, searchTerm: $searchTerm)
                        .environment(moviesVM)
                case .grid:
                    GridItemsView(
                        movies: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
                        searchTerm: $searchTerm
                    )
                    .environment(moviesVM)
                }
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            ItemsView(searchTerm: .constant(""), itemsView: .grid)
                .environment(MoviesViewModel())
        }
        .background(.bw10)
    }
}
