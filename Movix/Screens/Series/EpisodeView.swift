//
//  EpisodeView.swift
//  Movix
//
//  Created by Ancel Dev account on 4/3/25.
//

import SwiftUI

struct EpisodeView: View {
    let name: String
    let overview: String?
    let stillPath: String?
    
    @State private var stillImage: Image?
    @Environment(SerieViewModel.self) var serieVM
    var body: some View {
        VStack {
            if let stillImage {
                stillImage
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fit)
            }
            if let overview {
                OverviewView(title: name, overview: overview)
            }
        }
        .padding(.bottom, 16)
        .background(.bw40)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .task {
            if stillImage == nil {
                self.stillImage = await serieVM.loadPosterImage(imagePath: stillPath)
            }
        }
    }
}

#Preview {
    EpisodeView(
        name: "That '70s Pilot",
        overview: "While Eric Forman is swiping beer for his best friends Donna Pinciotti, Michael Kelso, and Steven Hyde, his parents Red and Kitty hint that he may be getting the old Vista Cruiser.  Now Eric can drive all of his friends – including the new foreign exchange student, Fez – to a Todd Rundgren concert in Milwaukee.  A minor snag occurs when Kelso's obnoxious girlfriend, Jackie Burkhart, finds out and invites herself along.  An even bigger snag occurs when Red tells Eric that he can't drive the car out of Point Place.",
        stillPath: "/rCu8eTlNaYOydOegoOXEDItspE8.jpg"
    )
    .environment(SerieViewModel())
}
