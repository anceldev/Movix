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
                                GeneralTabSerieView()
                            case .details:
                                Text("Details tab")
                            case .reviews:
                                Text("Reviews tab")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                        .frame(height: nil)
                        .padding(.horizontal, 16)
                    }
                    Spacer()
                }
                .environment(serieVM)
            }
            else {
                ProgressView()
                    .tint(.marsB)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(.bw10)
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
}

#Preview {
    NavigationStack {
        SerieScreen(serieId: 52)
            .environment(UserViewModel(user: User.preview))
    }
}
