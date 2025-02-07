//
//  PosterView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct PosterView: View {
    
    @Environment(MovieViewModel.self) var movieVM
    let posterPath: String?
    let duration: String
    let isAdult: Bool?
    let releasedDate: String?
    let genres: [Genre]?
    let id: Int
    
    @State private var posterImage: Image?

    init(movie: Movie) {
        self.posterPath = movie.posterPath
        self.duration = movie.duration
        self.isAdult = movie.isAdult
        self.releasedDate = movie.releaseDate?.releaseDate()
        self.genres = movie.genres
        self.id = movie.id
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
            
//            AsyncImage(url: posterURL) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                        .tint(.marsB)
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(27/40, contentMode: .fill)
//                case .failure:
//                    Image(systemName: "photo.slashed")
//                        .font(.largeTitle)
//                @unknown default:
//                    ProgressView()
//                        .tint(.marsA)
//                }
//            }
//            .clipped()
            
            LinearGradient(
                stops: [
                    .init(color: .bw10.opacity(0.59), location: 0),
                    .init(color: .bw10.opacity(0), location: 0.48),
                    .init(color: .bw10, location: 1)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            VStack {
                Spacer()

//                NavigationLink {
//                    ProvidersScreen(id: id)
//                        .navigationBarBackButtonHidden()
//                } label: {
//                    Label("Providers", systemImage: "play.display")
//                        .font(.system(size: 18))
//                        .padding(.horizontal, 16)
//                        .frame(height: 44)
//                        .background(LinearGradient(colors: [Color.marsA, Color.marsB], startPoint: .bottomLeading, endPoint: .topTrailing))
//                        .clipShape(Capsule())
//                }
                
                VStack(spacing: 8) {
                    if let genres = genres, !genres.isEmpty {
                        HStack(spacing: 8) {
                            ForEach(genres) { genre in
                                Text(genre.name)
                                    .font(.system(size: 12))
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
                .font(.system(size: 12))
                .padding(.top, 20)
                .padding(.bottom, 8)
            }
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            Task {
                self.posterImage = await movieVM.getPosterImage(posterPath: self.posterPath)
            }
        }
    }
}
#Preview(body: {
    NavigationStack {
        MovieScreen(movieId: Movie.preview.id)
//            .environment(AuthViewModel())
    }
})
