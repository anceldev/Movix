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
    @Environment(\.dismiss) private var dismiss
    @State private var serieVM = SerieViewModel()
    @State private var selectedTab: MediaTab = .general
    
    init(serieId: Int) {
        self.serieId = serieId
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        VStack {
            if let serie = serieVM.serie {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            PosterView(
                                posterPath: serie.posterPath,
                                duration: "\(serie.numberOfSeasons ?? 0) Se.",
                                isAdult: serie.isAdult,
                                releaseDate: serie.releaseDate?.releaseDate(),
                                genres: serie.genres
                            )
                            MediaActionsBar(mediaId: serieId, mediaType: .tv, rateAction: {
                                selectedTab = .general
                                proxy.scrollTo( "mediaTabs")
                            }, favoriteAction: toggleFavoriteSerie)
//                            if let title = serieVM.serie?.title {
//                                Text(title)
//                                    .font(.hauora(size: 20, weight: .semibold))
//                            }
                            OverviewView(title: serieVM.serie?.title, overview: serie.overview)
                            VStack {
                                CustomSegmentedControl(state: $selectedTab)
                                switch selectedTab {
                                case .general:
//                                    Text("General")
                                    GeneralTabSerieView()
                                case .details:
                                    Text("Details")
                                case .reviews:
                                    Text("Reviews")
                                }
                            }
                            .padding()
                        }
                         .environment(serieVM)
                        .environment(userVM)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            else {
                ProgressView()
                    .tint(.marsB)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(.bw10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: .top)
        .swipeToDismiss()
        .task {
            await serieVM.getSerieDetails(id: serieId)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Series")
                    }
                }
                .foregroundStyle(.blue1)
            }
        }
    }
    private func toggleFavoriteSerie() async {
        if let serie = serieVM.serie {
            await userVM.toggleFavoriteMovie(media: serie, mediaType: .tv)
        }
    }
}

#Preview {
    NavigationStack {
        SerieScreen(serieId: 52)
            .environment(UserViewModel(user: User.preview))
    }
}
