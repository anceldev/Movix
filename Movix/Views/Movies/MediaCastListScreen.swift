//
//  MediaCastListScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 9/5/25.
//

import SwiftUI

struct MediaCastListScreen: View {
    let cast: [Cast]
    let columns = Array<GridItem>(repeating: .init(.flexible()), count: 3)
    @Environment(NavigationManager.self) var navigationManager
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(cast) { actor in
                        Button {
                            navigationManager.navigate(to: .people(id: actor.id))
                        } label: {
                            ActorLink(imageUrl: actor.profilePath, name: actor.originalName)
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.bw10)
        .onAppear {
            print(cast)
        }
    }
}

#Preview {
    NavigationStack {
        MediaCastListScreen(cast: PreviewData.cast)
    }
    .environment(NavigationManager())
}
