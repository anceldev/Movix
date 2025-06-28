//
//  SerieScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 1/3/25.
//

import SwiftUI

enum MediaTab: String, CaseIterable, Identifiable, Hashable, Localizable {
    case general, details, reviews
    
    var id: Self { self }
    
    var localizedTitle: String {
        switch self {
        case .general:
            return NSLocalizedString("movie-tabs-general", comment: "General")
        case .details:
            return NSLocalizedString("movie-tabs-details", comment: "Details")
        case .reviews:
            return NSLocalizedString("movie-tabs-reviews", comment: "Reviews")
        }
    }
}

struct SerieScreen: View {
    
    let serieId: Int

    @Environment(UserViewModel.self) var userVM
    @Environment(\.dismiss) private var dismiss
    @Environment(NavigationManager.self) var routerDestination

    @State private var serieVM = SerieViewModel()
    @State private var selectedTab: MediaTab = .general
    
    var isFavorite: Bool {
        let media = userVM.user.series.first { $0.media.id == serieId }
        guard let media else { return false }
        return media.isFavorite
    }
    
    init(serieId: Int) {
        self.serieId = serieId
    }
    
    var body: some View {
        VStack {
            if let serie = serieVM.serie {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                                PosterMediaView(
                                    posterPath: serie.posterPath,
                                    duration: "\(serie.numberOfSeasons ?? 0) Se.",
                                    isAdult: serie.isAdult,
                                    releaseDate: serie.releaseDate?.releaseDate(),
                                    genres: serie.genres
                                )
                                MediaActionsBar(
                                    media: .init(id: serie.id, posterPath: serie.posterPath),
                                    mediaType: .serie,
                                    isFavorite: isFavorite,
                                    rateAction: {
                                        selectedTab = .general
                                        proxy.scrollTo( "mediaTabs")
                                    },
                                    favoriteAction: toggleFavoriteSerie)
//                            VStack(alignment: .leading) {
//                                Text("overview-title")
//                                    .font(.system(size: 22, weight: .medium))
//                                    .padding(.leading)
//                                OverviewView(serie.overview)
//                            }
//                            
                            VStack(spacing: 16) {
                                Text(serie.title)
                                    .font(.hauora(size: 28, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .multilineTextAlignment(.center)
                                
                                VStack(alignment: .leading) {
                                    Text("overview-title")
                                        .font(.system(size: 22, weight: .medium))
                                        .padding(.leading)
                                    OverviewView(serie.overview)
                                }
                            }
                            VStack {
                                CustomSegmentedControl(state: $selectedTab)
                                switch selectedTab {
                                case .general:
                                    GeneralTabSerieView(currentRate: userVM.getSerieRating(serieId: serieId))
                                case .details:
                                    DetailsTabView<TvSerie>(media: serieVM.serie!, similarAction: getSimilarSeries)
                                case .reviews:
                                    ReviewsList(id: serie.id, title: serie.title, mediaType: .serie)
                                }
                            }
                            .padding()
                            .id("mediaTabs")
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
                    routerDestination.navigateBack()
                } label: {
                    BackButton()
                }
            }
        }
    }
    private func getSimilarSeries() async -> [TvSerie]{
        return await serieVM.getRecommendedSeries(serieId: serieId)
    }
    private func toggleFavoriteSerie() async {
        if let serie = serieVM.serie {
            await userVM.toggleFavoriteMedia(media: serie, mediaType: .serie)
        }
    }
}

#Preview {
    NavigationStack {
        SerieScreen(serieId: 52)
            .environment(UserViewModel(user: PreviewData.user))
            .environment(NavigationManager())
    }
}
