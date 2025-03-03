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
    @Environment(SeriesViewModel.self) var seriesVM
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack(spacing: 8) {
                    Text("Series")
                        .font(.hauora(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                    HStack(spacing: 16) {
                        SearchField(
                            searchTerm: $searchTerm,
                            loadAction: loadSeries) {
                                seriesVM.searchedSeries.removeAll()
                            }
                        SearchBarButtons(showFilterSheet: $showFilterSheet, viewOption: $viewOption)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    Group {
                        switch viewOption {
                        case .row:
                            MediaRowLayout<TvSerie>(mediaItems: searchTerm.isEmpty ? seriesVM.trendingSeries : seriesVM.searchedSeries, mediaType: .tv)
                        case .gridx2:
                            GridItemsView<TvSerie>(
                                mediaItems: searchTerm.isEmpty ? seriesVM.trendingSeries : seriesVM.searchedSeries,
                                searchTerm: .constant(""),
                                mediaType: .tv,
                                columns: [GridItem(.flexible()), GridItem(.flexible())]
                            )
                        case .gridx3:
                            GridItemsView<TvSerie>(
                                mediaItems: searchTerm.isEmpty ? seriesVM.trendingSeries : seriesVM.searchedSeries,
                                searchTerm: .constant(""),
                                mediaType: .tv,
                                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                            )
                        }
                    }
                    VStack {
                        Button {
                            loadSeries()
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
            }
        }
        .animation(.easeIn, value: viewOption)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showFilterSheet) {
            Text("Filter screen")
        }
    }
    private func loadSeries() {
        Task {
            if searchTerm.isEmpty {
                await seriesVM.getTrendingSeries()
            }
            else {
                await seriesVM.getSearchedSeries(searchTerm: searchTerm)
            }
        }
    }
}

#Preview {
    SeriesScreen()
        .environment(SeriesViewModel())
}
