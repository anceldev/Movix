//
//  SeriesScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SeriesScreen: View {
    @State private var searchTerm = ""
    @State private var showFilterSheet = false
    
    @State private var viewOption: ViewOption = .gridx3
    @State private var seriesVM = SeriesViewModel()
    @Environment(NavigationManager.self) var navigationManager
    @Environment(UserViewModel.self) var userVM
    
    @State private var query = ""
    @State private var debouncedQuery = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("Series")
                        .font(.hauora(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                    HStack(spacing: 16) {
                        SearchField(query: $query, debounceQuery: $debouncedQuery)
                            .padding(.leading)
                        SearchBarButtons(showFilterSheet: $showFilterSheet, viewOption: $viewOption)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .environment(seriesVM)
                }
                VStack {
                    GridItemsView<TvSerie>(
                        mediaItems: debouncedQuery.isEmpty ? seriesVM.trendingSeries : seriesVM.series,
                        mediaType: .tv,
                        columns: viewOption == .gridx2 ? 2 : 3
                    )
                }
                .padding(.horizontal, 16)
                
                VStack {
                    Button {
                        search(query: debouncedQuery)
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.white)
                    }
                    .disabled(seriesVM.loadFlow == .loading)
                }
                .padding(.top, 4)
                .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.bw10)
            .withAppRouter()
        }
        .animation(.easeIn, value: viewOption)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showFilterSheet) {
            Text("Filter screen")
        }
        .onChange(of: debouncedQuery) { _, newValue in
            if newValue != "" {
                search(query: newValue)
            }
        }
    }
    private func search(query: String) {
        Task {
            if query != "" {
                await seriesVM.searchSeries(searchTerm: debouncedQuery)
            } else {
                await seriesVM.loadTrending()
            }
        }
    }
}

#Preview {
    @Previewable @State var nav = NavigationManager()
    NavigationStack(path: $nav.path) {
        SeriesScreen()
    }
    .environment(nav)
    .environment(UserViewModel(user: PreviewData.user))
}
