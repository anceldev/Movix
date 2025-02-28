//
//  MediaItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MediaItemsView: View {
    
    @Environment(MoviesViewModel.self) var moviesVM
    @Environment(SeriesViewModel.self) var seriesVM

    @Binding var searchTerm: String
    let viewOption: ViewOption
    let mediaType: MediaType
    
    var body: some View {
        @Bindable var moviesVM = moviesVM
        ScrollView(.vertical) {
                switch viewOption {
                case .row:
                    VStack {
                        ListItemsView(
//                            mediaItems: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
                            mediaItems: getMediaItems()
                            searchTerm: $searchTerm,
                            mediaType: mediaType
                        )
                        Button {
                            loadMediaItems()
                        } label: {
                            Label("Ver más", systemImage: "chevron.down")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.blue1)
                                .frame(maxWidth: .infinity)
                        }
                    }
                case .grid:
                    VStack {
                        GridItemsView(
                            movies: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
                            searchTerm: $searchTerm,
                            mediaType: mediaType
                        )
                        Button {
                            loadMediaItems()
                        } label: {
                            Label("Ver más", systemImage: "chevron.down")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.blue1)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
        }
    }
    private func getMediaItems<T:MediaItemProtocol>() -> [T] {
        switch mediaType {
        case .movie:
            return searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies
        case .tv:
            return searchTerm.isEmpty ? seriesVM.trendingSeries : []
        }
    }
    private func loadMediaItems() {
        Task {
            if searchTerm.isEmpty {
                switch mediaType {
                case .movie:
                    await moviesVM.getTrendingMovies()
                case .tv:
                    await seriesVM.getTrendingTvShows()
                }
            } else {
                switch mediaType {
                case .movie:
                    await moviesVM.searchMovies(searchTerm: searchTerm)
                case .tv:
                    return
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            MediaItemsView(searchTerm: .constant(""), viewOption: .grid, mediaType: .movie)
                .environment(MoviesViewModel())
                .environment(SeriesViewModel())
        }
        .background(.bw10)
    }
}
