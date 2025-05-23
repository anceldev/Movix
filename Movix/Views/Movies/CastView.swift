//
//  CastView.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct CastView: View {
    let cast: [Cast]
    @State private var actors: [Cast] = []
    @State private var animationInProgress = true
    @State private var loadedCount = 0
    @State private var showLoadAllButton = false
    @Environment(NavigationManager.self) var navigationManager
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("movie-tabs-general-actors-title")
                .font(.system(size: 22, weight: .medium))
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(actors) { actor in
                        Button {
                            navigationManager.navigate(to: .people(id: actor.id))
                        } label: {
                            ActorLink(
                                imageUrl: actor.profilePath,
                                name: actor.originalName
                            )
                            .transition(
                                .asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity)
                            )
                            .id("actor_\(actor.id)")
                        }
                    }
                    if showLoadAllButton && !animationInProgress {
                        VStack(alignment: .center) {
                            Button {
                                navigationManager.navigate(to: .mediaCastList(cast))
                            } label: {
//                                HStack(spacing: 0) {
                                    Text("view-all-button-label")
                                        .foregroundStyle(.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.hauora(size: 12, weight: .semibold))
                                        .frame(maxWidth: .infinity, alignment: .center)
//                                    Image(systemName: "chevron.right")
//                                        .foregroundStyle(.white)
//                                        .font(.system(size: 12))
//                                }
                            }
                        }
                        .transition(.opacity)
//                        .frame(maxWidth: 80)
                        .frame(width: 80)
                    }
                    
                }
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            loadInitialActors()
        }
    }
//    @ViewBuilder
//    func ActorLink(imageUrl: URL?, name: String) -> some View {
//        VStack(alignment: .center, spacing: 10) {
//            ZStack {
//                AsyncImage(url: imageUrl) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                            .tint(.marsB)
//                    case .success(let image):
//                        VStack {
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .offset(y: 8)
//                                .frame(width: 76, height: 76)
//                        }
//                        .clipped()
//                    case .failure(_):
//                        Image(systemName: "photo")
//                    @unknown default:
//                        ProgressView()
//                    }
//                }
//            }
//            .frame(width: 76, height: 76)
//            .background(.bw50)
//            .clipShape(.circle)
//            VStack {
//                Text(name)
//                    .foregroundStyle(.white)
//                    .fixedSize(horizontal: false, vertical: true)
//                    .lineLimit(2)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .frame(height: 30)
//            }
//        }
//        .font(.hauora(size: 12))
//        .frame(maxWidth: 80)
//    }
    private func loadInitialActors() {
        actors = []
        let initialCount = min(4, cast.count)
        animationInProgress = true
        func addNextActor(at index: Int) {
            guard index < initialCount else {
                animationInProgress = false
                loadedCount = initialCount
                
                if cast.count > initialCount {
                    withAnimation {
                        showLoadAllButton = true
                    }
                }
                
                return
            }
            withAnimation(.easeIn(duration: 0.9)) {
                actors.append(cast[index])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                addNextActor(at: index + 1)
            }
        }
        addNextActor(at: 0)
    }
}

#Preview {
    CastView(cast: PreviewData.cast)
        .environment(NavigationManager())
}
