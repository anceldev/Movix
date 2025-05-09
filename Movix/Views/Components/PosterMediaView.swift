//
//  PosterMediaView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct PosterMediaView: View {
    
    let posterPath: String?
    let duration: String
    let isAdult: Bool?
    let releasedDate: String?
    let genres: [Genre]?
    let mediaType: MediaType
    
    @State private var posterImage: Image?

    init(posterPath: String? = nil, duration: String, isAdult: Bool? = nil, releaseDate: String? = nil, genres: [Genre]? = nil, mediaType: MediaType = .serie){
        self.posterPath = posterPath
        self.duration = duration
        self.isAdult = isAdult
        self.releasedDate = releaseDate
        self.genres = genres
        self.mediaType = mediaType
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.bw20, .bw40], startPoint: .top, endPoint: .bottom)
            if let posterPath {
                if let poster = posterImage {
                    poster
                        .resizable()
                        .aspectRatio(27/40, contentMode: .fill)
                } else {
                    LinearGradient(colors: [.bw20, .bw40], startPoint: .top, endPoint: .bottom)
                        .aspectRatio(27/40, contentMode: .fill)
                }
            }
            else {
                TimeoutProgressView()
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
            VStack(spacing: 0) {
                Spacer()
//                Button {
//                    
//                } label: {
//                    HStack(spacing: 8) {
//                        Image(systemName: "play.fill")
//                        Text("Providers")
//                            .font(.hauora(size: 20))
//                    }
//                    .padding(.horizontal, 16)
//                    .frame(height: 44)
//                    .background(.marsA)
//                    .clipShape(.capsule)
//                }
//                .buttonStyle(.capsuleButton)
                
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
        .task {
            if let posterPath {
                if self.posterImage == nil {
                    let poster = await ImageLoader.shared.loadImage(for: posterPath, size: .poster)
                    withAnimation(.easeIn) {
                        self.posterImage = poster
                    }
                }
            }
        }
    }
}
