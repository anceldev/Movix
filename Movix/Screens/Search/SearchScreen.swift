//
//  SearchScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

enum SearchTab: String, CaseIterable, Identifiable, Hashable {
    case all
    case movies
    case tvShow = "Tv Shows"
    var id: Self { self }
}

struct SearchScreen: View {
    
    @State private var showFilterSheet: Bool = false
    @State private var viewOption: ViewOption = .grid
    @State private var searchTerm = ""
    @State private var selectedTab: SearchTab = .movies
    @Environment(MoviesViewModel.self) private var moviesVM
    @Environment(SeriesViewModel.self) private var seriesVM
    
    var body: some View {
        @Bindable var moviesVM = moviesVM
        NavigationStack {
            VStack {
                Text("Search")
                    .font(.hauora(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                SearchBar(searchTerm: $searchTerm,
                    filterAction: {
                    showFilterSheet = true
                }, viewOption: $viewOption)
                VStack(spacing: 0) {
                    CustomSegmentedControl(state: $selectedTab)
                    switch selectedTab {
                    case .all:
                        Text("This is all")
                    case .movies:
                        MediaItemsView(
                            searchTerm: $searchTerm,
                            viewOption: viewOption,
                            mediaType: .movie
                        )
                    case .tvShow:
                        SearchedTvShows()
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
        })
        .environment(moviesVM)
        .environment(seriesVM)
    }
}

#Preview {
    SearchScreen()
        .environment(MoviesViewModel())
        .environment(SeriesViewModel())
}
