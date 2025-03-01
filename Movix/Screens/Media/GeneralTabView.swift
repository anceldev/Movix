//
//  GeneralTabView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct GeneralTabView: View {
    @Environment(MovieViewModel.self) var movieVM
    @Environment(UserViewModel.self) var userVM

    @State private var currentRate: Float
    @State private var castVM: CastViewModel
    
    init(id: Int, currentRate: Int? = nil) {
        self._castVM = State(initialValue: CastViewModel(id: id))
        self._currentRate = State(initialValue: Float(currentRate != nil ? currentRate! : 0))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Actors")
                    .font(.system(size: 22, weight: .medium))
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(castVM.cast) { actor in
                            NavigationLink {
                                ActorScreen(id: actor.id)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                ActorLink(
                                    imageUrl: actor.profilePath,
                                    name: actor.originalName
                                )
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            RatingView(currentRate: $currentRate, action: rateMovie)
            Spacer()
        }
        .padding(16)
        .onChange(of: currentRate) {
            print(Int(currentRate))
        }
    }
    
    @ViewBuilder
    func ActorLink(imageUrl: URL?, name: String) -> some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .tint(.marsB)
                    case .success(let image):
                        VStack {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .offset(y: 8)
                                .frame(width: 76, height: 76)
                        }
                        .clipped()
                    case .failure(_):
                        Image(systemName: "photo")
                    @unknown default:
                        ProgressView()
                    }
                }
            }
            .frame(width: 76, height: 76)
            .background(.bw50)
            .clipShape(.circle)
            VStack {
                Text(name)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 30)
            }
        }
        .font(.system(size: 12))
        .frame(maxWidth: 80)
    }
    private func rateMovie() {
        Task {
            guard let movie = movieVM.movie else { return }
            await userVM.addRating(movie: movie, rating: Int(currentRate))
        }
    }
}
//#Preview(body: {
//    NavigationStack {
//        MediaScreen(mediaId: Movie.preview.id, mediaType: .movie)
//            .environment(MovieViewModel())
//            .environment(UserViewModel(user: User.preview))
//    }
//})
