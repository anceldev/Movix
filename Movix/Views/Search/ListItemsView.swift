//
//  ListItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ListItemsView<T: MediaItemProtocol>: View {
    
    let mediaItems: [T]
    @Binding var searchTerm: String
    @Environment(MoviesViewModel.self) var moviesVM
    @Environment(SeriesViewModel.self) var seriesVM
    @Environment(UserViewModel.self) var userVM
    @State private var showLoadButton = false
    var mediaType: MediaType

    var body: some View {
        @Bindable var viewModel = moviesVM
        LazyVStack(alignment: .leading) {
            var seenMediaIDs = Set<Int>()
            ForEach(mediaItems.filter { seenMediaIDs.insert($0.id).inserted }) { media in
                NavigationLink {
                    Group {
                        switch mediaType {
                        case .movie:
                            Text("Movies")
                        case .tv:
                            SerieScreen(serieId: media.id)
                                .navigationBarBackButtonHidden()
                        }
                    }
                } label: {
                    MediaRow(title: media.title, backdropPath: media.backdropPath, releaseDate: media.releaseDate, voteAverage: media.voteAverage) {
                        Image(.heartIcon)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            print("mediaItems is type: ", type(of: T.self))
        }
    }
}

//#Preview {
//    NavigationStack {
//        ListItemsView(mediaItems: [ShortMovie.preview], searchTerm: .constant(""), mediaType: .movie)
//            .environment(MoviesViewModel())
//            .environment(SeriesViewModel())
//            .environment(UserViewModel(user: User.preview))
//    }
//}
