//
//  SeriesScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SeriesScreen: View {
//    @State private var query = ""
//    @State private var debouncedQuery = ""
    let query: String
    @State private var showFilterSheet = false
    @State private var viewOption: ViewOption = .gridx3
//    @State private var seriesVM = SeriesViewModel()
    @Environment(SeriesViewModel.self) var seriesVM
    @State private var results = [TvSerie]()
    
    @Environment(NavigationManager.self) var navigationManager
    @Environment(UserViewModel.self) var userVM
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
//                SearchBarView(
//                    title: NSLocalizedString("series-tab-label", comment: "movies screen"),
//                    query: $query,
//                    debounceQuery: $debouncedQuery,
//                    showFilterSheet: $showFilterSheet,
//                    viewOption: $viewOption
//                )
                VStack {
                    ScrollView(.vertical) {
                        GridItemsView<TvSerie>(
                            mediaItems: query.isEmpty ? seriesVM.trendingSeries : seriesVM.series,
                            mediaType: .serie,
                            viewOption: viewOption
                        )
//                        VStack {
//                            Button {
//                                search(query: debouncedQuery)
//                            } label: {
//                                Image(systemName: "chevron.down")
//                                    .foregroundStyle(.white)
//                            }
//                            .disabled(seriesVM.loadFlow == .loading)
//                        }
//                        .padding(.top, 4)
//                        .padding(.bottom, 8)
                    }
                    .scrollIndicators(.hidden)
                }
                .padding(.horizontal, 16)
            }
            .background(.bw10)
            .withAppRouter()
        }
        .animation(.easeIn, value: viewOption)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showFilterSheet) {
            FilteredSearchScreen<TvSerie>(results: $results, mediaType: .serie)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
//        .onChange(of: debouncedQuery) { _, newValue in
//            if newValue != "" {
//                search(query: newValue)
//            }
//        }
        .enableInjection()
    }
//    private func search(query: String) {
//        Task {
//            if query != "" {
//                await seriesVM.searchSeries(searchTerm: debouncedQuery)
//            } else {
//                await seriesVM.loadTrending()
//            }
//        }
//    }
}

#Preview {
    @Previewable @State var nav = NavigationManager()
    NavigationStack(path: $nav.path) {
        SeriesScreen(query: "")
    }
    .environment(nav)
    .environment(UserViewModel(user: PreviewData.user))
}
