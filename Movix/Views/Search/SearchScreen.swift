//
//  SearchScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI
import Inject

enum SearchTab: String, CaseIterable, Identifiable, Hashable, Localizable {
    case movies
    case tv
    var id: Self { self }
    
    var localizedTitle: String {
        switch self {
        case .movies:
            return NSLocalizedString("movies-tab-label", comment: "Details")
        case .tv:
            return NSLocalizedString("series-tab-label", comment: "Reviews")
        }
    }
}

struct SearchScreen: View {
    @State private var query = ""
    @State private var debouncedQuery = ""
    @State private var showFilterSheet = false
    @State private var viewOption: ViewOption = .gridx3
    @State private var selectedTab: SearchTab = .movies
    
    @Environment(SeriesViewModel.self) var series
    @Environment(MoviesViewModel.self) var movies

    @ObserveInjection var forceRedraw

    var body: some View {
        VStack {
            SearchBarView(
                title: NSLocalizedString("search-tab-title", comment: "search screen"),
                query: $query,
                debounceQuery: $debouncedQuery,
                showFilterSheet: $showFilterSheet,
                viewOption: $viewOption
            )
            VStack {
                CustomSegmentedControl(state: $selectedTab)
                switch selectedTab {
                case .movies:
                    MoviesScreen(query: debouncedQuery)
                case .tv:
                    SeriesScreen(query: debouncedQuery)
                }
            }
            VStack {
                Button {
                    search(query: debouncedQuery)
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.white)
                }
//                .disabled(seriesVM.loadFlow == .loading)
            }
            .padding(.top, 4)
            .padding(.bottom, 8)
        }
        .background(.bw10)
        // Text("search-tab-title")
        //     .font(.hauora(size: 22, weight: .semibold))
        //     .foregroundStyle(.white)
        //     .frame(maxWidth: .infinity, maxHeight: .infinity)
        //     .background(.bw10)
        .enableInjection()
        .onChange(of: debouncedQuery) { _, newValue in
            if newValue != "" {
                search(query: newValue)
            }
        }
    }
    private func search(query: String) {
        Task {
            if selectedTab == .movies {
                if query != "" {
                    await movies.searchMovies(searchTerm: debouncedQuery)
                } else {
                    await movies.loadTrending()
                }
            } else {
                if query != "" {
                    await series.searchSeries(searchTerm: debouncedQuery)
                } else {
                    await series.loadTrending()
                }
            }
        }
    }
}

#Preview {
    SearchScreen()
}
