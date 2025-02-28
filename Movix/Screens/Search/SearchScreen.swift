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
    @State private var itemsView: ViewOption = .grid
    @State private var searchTerm = ""
    @State private var selectedTab: SearchTab = .movies
    @Environment(MoviesViewModel.self) private var moviesVM
    
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
                }, itemsView: $itemsView)
                VStack(spacing: 0) {
                    CustomSegmentedControl(state: $selectedTab)
                    switch selectedTab {
                    case .all:
                        Text("This is all")
                    case .movies:
                        ItemsView(
                            searchTerm: $searchTerm,
                            itemsView: itemsView
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
        .environment(moviesVM)
    }
}

#Preview {
    SearchScreen()
        .environment(MoviesViewModel())
}
