//
//  MediaActionsBar.swift
//  Movix
//
//  Created by Ancel Dev account on 1/3/25.
//

import SwiftUI

struct MediaActionsBar: View {
    let media: SupabaseMedia
    let mediaType: MediaType
    var isFavorite: Bool
    let rateAction: () -> Void
    let favoriteAction: () async -> Void
    
    @Environment(UserViewModel.self) var userVM
    @Environment(NavigationManager.self) var routerDestinationManager
    @State private var showListSelector = false
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation {
                    rateAction()
                }
            } label: {
                ActionBarButtonLabel(
                    label: NSLocalizedString("movie-tabbar-rate-label", comment: "Rate"),
                    imageName: "rate",
                    isOn: mediaType == .movie
                    ? userVM.user.movies.contains(where: { $0.media.id == media.id })
                    : userVM.user.series.contains(where: { $0.media.id == media.id })
                )
            }
            Button {
                Task {
                    await favoriteAction()
                }
            } label: {
                ActionBarButtonLabel(
                    label: NSLocalizedString("movie-tabbar-favorites-label", comment: "Favorites"),
                    imageName: "heart-icon",
                    isOn: isFavorite
                )
            }
            Button {
                showListSelector.toggle()
            } label: {
                ActionBarButtonLabel(
                    label: NSLocalizedString("lists-tab-label", comment: "Lists"),
                    imageName: "shop",
                    isOn: false
                )
            }
            Button {
                routerDestinationManager.navigate(to: .providers(id: media.id, mediaType: mediaType))
            } label: {
                VStack(spacing: 12) {
                   VStack {
                       Image(.providersIcon)
                           .resizable()
                           .frame(width: 24, height: 24)
                           .padding(8)
                           .background(
                               LinearGradient(colors: [Color.marsA, Color.marsB], startPoint: .bottomLeading, endPoint: .topTrailing)
                           )
                           .clipShape(.circle)
                           .foregroundStyle(.white)
                   }
                   .frame(width: 30, height: 30)
                   Text("movie-tabbar-providers-label")
                       .font(.hauora(size: 12))
                       .foregroundStyle(.white)
               }
                .frame(width: 75)
            }
        }
        .padding(.vertical, 32)
        .sheet(isPresented: $showListSelector) {
            ListSelectorScreen(media: media, mediaType: mediaType)
                .environment(userVM)
        }
    }
    private func toggleFavoriteMedia() {
        Task {
            await favoriteAction()
        }
    }
}

struct ActionBarButtonLabel: View {
    let label: String
    let imageName: String
    let isOn: Bool
    
    var image: Image {
        if isOn {
            return Image(imageName)
        }
        else {
            return Image("\(imageName)-disabled")
        }
    }
    var body: some View {
        VStack(spacing: 8) {
            VStack {
                image
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(isOn ? .blue1 : .bw50)
            }
            .frame(width: 30, height: 30)
            Text(label)
                .font(.hauora(size: 12))
                .foregroundStyle(isOn ? .blue1 : .bw50)
        }
        .frame(width: 75)
    }
}

#Preview(body: {
    MediaActionsBar(media: .init(id: 24, posterPath: nil), mediaType: .movie, isFavorite: true, rateAction: {}, favoriteAction: {})
        .environment(UserViewModel(user: PreviewData.user))
        .environment(NavigationManager())
        .background(.bw10)
})
