//
//  DetailsTabView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct DetailsTabView: View {
    let movie: Movie
    @Environment(MoviesViewModel.self) var moviesVM
    @State private var showSimilar = false
    
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0, maximum: 130), spacing: 10, alignment: .topLeading),
        GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0, alignment: .topLeading)
    ]
    
    let orderedKeys = ["Duration", "Release date", "Genres", "Homepage"]
    
    var movieDetails: [String : String] {
        var details: [String : String] = [:]
        if let homepageURL = movie.homepageURL {
            details["Homepage"] = homepageURL.absoluteString
        }
        if !movie.duration.isEmpty {
            details["Duration"] = movie.duration
        }
        if let genres = movie.genres, !genres.isEmpty {
            details["Genres"] = genres.map { $0.name }.joined(separator: ", ")
        }
        if let releaseDate = movie.releaseDate {
            details["Release Date"] = DateFormatter.localizedString(from: releaseDate, dateStyle: .medium, timeStyle: .none)
        }
        
        return details
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                ForEach(orderedKeys, id: \.self) { key in
                    if let value = movieDetails[key] {
                        Text(key)
                            .font(.hauora(size: 14))
                            .foregroundStyle(.white)
                        Text(value)
                            .font(.hauora(size: 14))
                            .foregroundStyle(.bw50)
                    }
                }
            }
//            VStack {
//                ScrollView(.vertical) {
//                    
//                GridItemsView(
//                    movies: moviesVM.similarMovies,
//                    searchTerm: .constant("")
//                )
//                .environment(moviesVM)
//                }
//            }
//            .frame(maxHeight: showSimilar ? .infinity : nil)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .padding(.bottom, 24)
        .onAppear {
            getSimilar(movieId: movie.id)
        }
    }
    private func getSimilar(movieId: Int) {
        Task {
            await moviesVM.getSimilarMovies(movieId: movieId)
        }
    }
}

#Preview {
    DetailsTabView(movie: Movie.preview)
        .environment(MoviesViewModel())
}
