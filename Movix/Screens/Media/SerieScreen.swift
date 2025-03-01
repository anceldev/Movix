//
//  SerieScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 1/3/25.
//

import SwiftUI

struct SerieScreen: View {
    
    let serieId: Int

    @Environment(UserViewModel.self) var userVM
    @State private var serieVM = SerieViewModel()
    @State private var selectedTab: MediaTab = .general
    
    var body: some View {
        VStack {
            if let serie = serieVM.serie {
                VStack {
                    MediaView(overview: serie.overview) {
                        PosterView(
                            posterPath: serie.posterPath,
                            duration: "\(serie.numberOfSeasons ?? 0) Se.",
                            isAdult: serie.isAdult,
                            releaseDate: serie.releaseDate?.releaseDate(),
                            genres: serie.genres
                        )
                    } tabContent: {
                        VStack {
                            CustomSegmentedControl(state: $selectedTab)
                            switch selectedTab {
                            case .general:
                                Text("General tab")
                            case .details:
                                Text("Details tab")
                            case .reviews:
                                Text("Reviews tab")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                        .frame(height: nil)
                    }
                    Spacer()
                }
            }
            else {
                ProgressView()
                    .tint(.marsB)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(.bw10)
        .ignoresSafeArea(.all)
        .task {
            await serieVM.getSerieDetails(id: serieId)
        }
    }
}

#Preview {
    SerieScreen(serieId: 52)
        .environment(UserViewModel(user: User.preview))
}
