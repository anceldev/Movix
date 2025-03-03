//
//  MediaItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MediaItemsView: View {
    
//    @Environment(MoviesViewModel.self) var moviesVM
//    @Environment(SeriesViewModel.self) var seriesVM
    

    @Binding var searchTerm: String
    let viewOption: ViewOption
    var mediaType: MediaType
    
    var body: some View {
//        @Bindable var moviesVM = moviesVM
        ScrollView(.vertical) {
//            switch viewOption {
//            case .row:
//                <#code#>
//            case .gridx2:
//                <#code#>
//            case .gridx3:
//                <#code#>
//            }
//                switch viewOption {
//                case .row:
//                    VStack {
//                        switch mediaType {
//                            case .movie:
//                            ListItemsView(
//                                mediaItems: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
//                                searchTerm: $searchTerm,
//                                mediaType: mediaType
//                            )
//                        case .tv:
//                            ListItemsView(
//                                mediaItems: searchTerm.isEmpty ? seriesVM.trendingSeries : [],
//                                searchTerm: $searchTerm,
//                                mediaType: mediaType
//                            )
//                        }
//                        
//                        Button {
//                            loadMediaItems()
//                        } label: {
//                            Label("Ver más", systemImage: "chevron.down")
//                                .labelStyle(.iconOnly)
//                                .foregroundStyle(.blue1)
//                                .frame(maxWidth: .infinity)
//                        }
//                    }
//                case .grid:
//                    VStack {
//                        switch mediaType {
//                        case .movie:
//                            GridItemsView(
//                                movies: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
//                                searchTerm: $searchTerm,
//                                mediaType: mediaType
//                            )
//
//                        case .tv:
//                            GridItemsView(
//                                movies: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
//                                searchTerm: $searchTerm,
//                                mediaType: mediaType
//                            )
//
//                        }
//
//                        Button {
//                            loadMediaItems()
//                        } label: {
//                            Label("Ver más", systemImage: "chevron.down")
//                                .labelStyle(.iconOnly)
//                                .foregroundStyle(.blue1)
//                                .frame(maxWidth: .infinity)
//                        }
//                    }
                }
//        }
//        .onChange(of: mediaType) { oldValue, newValue in
//            print("Media type is", newValue)
//        }
    }

    private func loadMediaItems() {
//        Task {
//            if searchTerm.isEmpty {
//                switch mediaType {
//                case .movie:
//                    await moviesVM.getTrendingMovies()
//                case .tv:
//                    await seriesVM.getTrendingSeries()
//                }
//            } else {
//                switch mediaType {
//                case .movie:
//                    await moviesVM.searchMovies(searchTerm: searchTerm)
//                case .tv:
//                    return
//                }
//            }
//        }
    }
}

//#Preview {
//    NavigationStack {
//        VStack {
//            MediaItemsView(searchTerm: .constant(""), viewOption: .grid, mediaType: .movie)
//                .environment(MoviesViewModel())
//                .environment(SeriesViewModel())
//        }
//        .background(.bw10)
//    }
//}
