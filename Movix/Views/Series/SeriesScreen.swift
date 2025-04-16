//
//  SeriesScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct CustomSearchField: View {
    @Binding var text: String
    var onClear: () -> Void
    var onTextChange: (String) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar películas", text: Binding(
                get: { text },
                set: { onTextChange($0) }
            ))
            
            if !text.isEmpty {
                Button(action: onClear) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .transition(.scale)
                .animation(.default, value: text.isEmpty)
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct SeriesScreen: View {
    @State private var searchTerm = ""
    @State private var showFilterSheet = false
    
    @State private var viewOption: ViewOption = .gridx3
    @Environment(SeriesViewModel.self) var seriesVM
    @Environment(NavigationManager.self) var navigationManager
    
    @State private var query = ""
    @State private var debouncedQuery = ""

    var body: some View {
        @Bindable var routerDestination = navigationManager
        @Bindable var seriesVM = seriesVM
        VStack {
            NavigationStack(path: $routerDestination.path) {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Series")
                            .font(.hauora(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                        HStack(spacing: 16) {
                            SearchField(searchTerm: $query, debounceQuery: $debouncedQuery)
                                .padding(.leading)
                            
                            SearchBarButtons(showFilterSheet: $showFilterSheet, viewOption: $viewOption)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .environment(seriesVM) //
                    }
//                    Group {
//                        switch viewOption {
//                        case .gridx2:
////                            GridItemsView<TvSerie>(
////                                mediaItems: searchTerm.isEmpty ? seriesVM.trendingSeries : seriesVM.searchedSeries,
////                                searchTerm: .constant(""),
////                                mediaType: .tv,
////                                columns: [GridItem(.flexible()), GridItem(.flexible())]
////                            )
//                            GridItemsView<TvSerie>(
//                                mediaItems: debouncedQuery.isEmpty ? seriesVM.trendingSeries : seriesVM.series,
//                                searchTerm: .constant(""),
//                                mediaType: .tv,
//                                columns: [GridItem(.flexible()), GridItem(.flexible())]
//                            )
//                        case .gridx3:
////                             GridItemsView<TvSerie>(
////                                 mediaItems: searchTerm.isEmpty ? seriesVM.trendingSeries : seriesVM.searchedSeries,
////                                 searchTerm: .constant(""),
////                                 mediaType: .tv,
////                                 columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
////                             )
//                            GridItemsView<TvSerie>(
//                                mediaItems: debouncedQuery.isEmpty ? seriesVM.trendingSeries : seriesVM.series,
//                                searchTerm: .constant(""),
//                                mediaType: .tv,
//                                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
//                            )
//                        }
//                    }
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
                .withAppRouter()
            }
        }
        .animation(.easeIn, value: viewOption)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showFilterSheet) {
            Text("Filter screen")
        }
        .onChange(of: debouncedQuery) { _, newValue in
            search(query: newValue)
        }
    }
    private func search(query: String) {
        Task {
            await seriesVM.getSearchedSeries(searchTerm: debouncedQuery)
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
        .environment(NavigationManager())
}
