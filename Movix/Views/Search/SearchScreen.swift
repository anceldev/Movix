//
//  SearchScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

enum SearchTab: String, CaseIterable, Identifiable, Hashable, Localizable {
    case all
    case movies
    case tv
    var id: Self { self }
    
    var localizedTitle: String {
        switch self {
        case .all:
            return NSLocalizedString("all-tab-label", comment: "All")
        case .movies:
            return NSLocalizedString("movie-tabs-label", comment: "Details")
        case .tv:
            return NSLocalizedString("series-tabs-label", comment: "Reviews")
        }
    }
}
//enum SearchFlow {
//    case searching
//    case success
//    case error(Error)
//}

struct SearchScreen: View {
    
    @State private var showFilterSheet: Bool = false
    @State private var viewOption: ViewOption = .gridx2
    @State private var searchTerm = ""
    @State private var selectedTab: SearchTab = .tv
    @State private var mediaType: MediaType = .serie
    
    @Environment(MoviesViewModel.self) private var moviesVM
    @Environment(SeriesViewModel.self) private var seriesVM
    @Environment(UserViewModel.self) private var userVM
    
    var body: some View {
        @Bindable var moviesVM = moviesVM
        NavigationStack {
            VStack {
                Text("Search")
                    .font(.hauora(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                VStack(spacing: 0) {
                    CustomSegmentedControl(state: $selectedTab)
                    switch selectedTab {
                    case .all:
                        Text("This is all")
                    case .movies, .tv:
                        Text("This is movies or tv")
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.bw10)
            .sheet(isPresented: $showFilterSheet) {
                Text("Filter screen")
            }
        }
        .onChange(of: selectedTab, { oldValue, newValue in
            searchTerm = ""
            if newValue == .movies {
                mediaType = .movie
            }
            else if newValue == .tv {
                mediaType = .serie
            }
        })
        .environment(moviesVM)
        .environment(userVM)
        .environment(seriesVM)
    }
    private func searchMovies() {
        Task {
            await moviesVM.loadTrending()
        }
    }
}

#Preview {
    SearchScreen()
        .environment(MoviesViewModel())
        .environment(SeriesViewModel())
        .environment(UserViewModel(user: PreviewData.user))
}
