//
//  PosterView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct PosterView: View {
    
    let posterPath: String?
    let duration: String
    let isAdult: Bool?
    let releasedDate: String?
    let genres: [Genre]?
    
    @State private var posterImage: Image?
    
    init(posterPath: String?, duration: String, isAdult: Bool?, releaseDate: String?, genres: [Genre]?){
        self.posterPath = posterPath
        self.duration = duration
        self.isAdult = isAdult
        self.releasedDate = releaseDate
        self.genres = genres
    }

    var body: some View {
        ZStack {
            Color.gray
                .aspectRatio(27/40, contentMode: .fill)
            if let poster = posterImage {
                poster
                    .resizable()
                    .aspectRatio(27/40, contentMode: .fill)
            }
            else {
                ProgressView()
                    .tint(.marsB)
            }
            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.59), location: 0),
                    .init(color: .black.opacity(0), location: 0.48),
                    .init(color: .black, location: 1)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            VStack {
                Spacer()
                VStack(spacing: 8) {
                    if let genres = genres, !genres.isEmpty {
                        HStack(spacing: 8) {
                            ForEach(genres) { genre in
                                Text(genre.name)
                                    .font(.hauora(size: 12))
                            }
                        }
                    }
                    HStack {
                        if let releasedDate {
                            Text(releasedDate)
                            Text("|")
                        }
                        Text(duration)
                        Text("|")
                        Text(isAdult ?? false ? "18+" : "13+")
                    }
                }
                .font(.hauora(size: 12))
                .padding(.top, 20)
                .padding(.bottom, 8)
            }
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            Task {
                self.posterImage = await HTTPClient.getPosterImage(posterPath: self.posterPath)
            }
        }
    }
}
//#Preview(body: {
//    NavigationStack {
//        MediaScreen(mediaId: Movie.preview.id, mediaType: .movie)
////            .environment(AuthViewModel())
//    }
//})
