//
//  DetailsTabView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct DetailsTabView<T: MediaTMDBProtocol>: View {
    let media: T
    let similarAction: () async -> [T]
    @State private var similarMedia: [T] = []
    @Environment(UserViewModel.self) var userVM
    
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 0, maximum: 130), spacing: 10, alignment: .topLeading),
        GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0, alignment: .topLeading)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                if !media.originCountry.isEmpty {
                    Text("Countries")
                        .font(.hauora(size: 14))
                        .foregroundStyle(.white)
                    Text(userVM.getMediaCountries(media.originCountry))
                        .font(.hauora(size: 14))
                        .foregroundStyle(.bw50)
                }
                
                if let genres = media.genres, !genres.isEmpty {
                    Text("Genres")
                        .font(.hauora(size: 14))
                        .foregroundStyle(.white)
                    Text(genres.map({ $0.name }).joined(separator: ", "))
                        .font(.hauora(size: 14))
                        .foregroundStyle(.bw50)
                }
                if let releaseDate = media.releaseDate {
                    Text(type(of: media) == Movie.Type.self ? "Release date" : "First air episode")
                        .font(.hauora(size: 14))
                        .foregroundStyle(.white)
                    Text(DateFormatter.localizedString(from: releaseDate, dateStyle: .medium, timeStyle: .none))
                        .font(.hauora(size: 14))
                        .foregroundStyle(.bw50)
                }
                if let homepage = media.homepage {
                    Text("Homepage")
                        .font(.hauora(size: 14))
                        .foregroundStyle(.white)
                    Link(destination: homepage) {
                        Text(homepage.absoluteString)
                            .font(.hauora(size: 14))
                            .foregroundStyle(.blue1)
                            .multilineTextAlignment(.leading)
                    }
                }

                if let status = media.status, status != "" {
                    Text("Status")
                        .font(.hauora(size: 14))
                        .foregroundStyle(.white)
                    Text(status)
                        .font(.hauora(size: 14))
                        .foregroundStyle(.bw50)
                }
                
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("Recommendations")
                    .font(.system(size: 22, weight: .medium))
                VStack {
                    if !similarMedia.isEmpty {
                        GridItemsView(
                            mediaItems: similarMedia,
                            mediaType: type(of: T.self) == type(of: Movie.self) ? .movie : .tv,
                            viewOption: .gridx3
                        )
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 24)
        .task {
            await userVM.getCountries()
            let similar = await similarAction()
            withAnimation(.easeIn) {
                self.similarMedia = similar
            }
        }
        .onAppear {
            print(type(of: T.self))
            if (type(of: T.self) == type(of: Movie.self)) {
                print("Is Movie")
            }
            else {
                print("Is serie")
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailsTabView<Movie>(media: PreviewData.movie, similarAction: {  return []})
            .environment(UserViewModel(user: PreviewData.user))
            .padding(24)
    }
}
