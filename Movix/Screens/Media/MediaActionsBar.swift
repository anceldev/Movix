//
//  MediaActionsBar.swift
//  Movix
//
//  Created by Ancel Dev account on 1/3/25.
//

import SwiftUI

struct MediaActionsBar: View {
    let rateAction: () -> Void
    let favoriteAction: () -> Void
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    rateAction()
                }
            } label: {
                ActionBarButtonLabel(label: "Rate", imageName: "rate", isOn: false)
            }
            Button {
                favoriteAction()
            } label: {
                ActionBarButtonLabel(
                    label: "Favorites",
                    imageName: "heart-icon",
                    isOn: false
                )
            }
            NavigationLink {
                Text("Lists Screen")
            } label: {
                ActionBarButtonLabel(label: "My List", imageName: "shop", isOn: false)
            }
            NavigationLink {
                Text("ProvidersScreen")
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
                    Text("Providers")
                        .font(.hauora(size: 12))
                        .foregroundStyle(.white)
                }
                .frame(width: 60)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    MediaActionsBar(rateAction: {}, favoriteAction: {})
}
