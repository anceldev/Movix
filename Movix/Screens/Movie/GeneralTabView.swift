//
//  GeneralTabView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct GeneralTabView: View {
//    let cast: [Cast]
    @State private var currentRate: Float = 0.0
    @Environment(MovieViewModel.self) var movieVM
    
    @State private var castVM: CastViewModel
    
    init(id: Int) {
        self._castVM = State(initialValue: CastViewModel(id: id))
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
                                Text(actor.originalName)
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
            RatingView(currentRate: $currentRate)
            Spacer()
        }
        .padding(16)
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
}
#Preview(body: {
    NavigationStack {
        MovieScreen(movieId: Movie.preview.id)
            .environment(MovieViewModel())
//            .environment(AuthViewModel())
    }
})
