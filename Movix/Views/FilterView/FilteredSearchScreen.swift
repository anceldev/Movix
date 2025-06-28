//
//  FilteredSearchScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 15/5/25.
//

import SwiftUI

struct FilteredSearchScreen<T: MediaTMDBProtocol>: View {
    @Binding var results: [T]
    
    var mediaType: MediaType
    @State private var filterVM = FilterViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Text("media-filter-title")
                    .font(.hauora(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                HStack(spacing: 16){
                    HStack {
                        Text("media-filter-sort-label")
                            .font(.hauora(size: 14, weight: .semibold))
                        Picker("Sort", selection: $filterVM.selectedSortAttribute) {
                            ForEach(FilterSortAttribute.allCases) { attribute in
                                Text(attribute.label)
                                    .tag(attribute)
                            }
                        }
                        .tint(.white)
                        .background(.bw40)
                        .clipShape(.capsule)
                    }
                    Spacer(minLength: 0)
                    HStack {
                        Text("media-filter-order")
                            .font(.hauora(size: 14, weight: .semibold))
                        Picker("Sort", selection: $filterVM.selectedSortOrder) {
                            ForEach(FilterSortOrder.allCases) { order in
                                Text(order.label)
                                    .tag(order)
                            }
                        }
                        .tint(.white)
                        .background(.bw40)
                        .clipShape(.capsule)
                    }
                }
                
                NavigationLink {
                    Text("Year selection")
                } label: {
                    FilteredSearchScreenRow(
                        name: NSLocalizedString("media-filter-rating", comment: "rating"),
                        isEmpty: filterVM.selectedVote == nil ? true : false
                    )
                }
                NavigationLink {
                    GenreFilterList(genres: filterVM.genres)
                        .environment(filterVM)
                        .navigationBarBackButtonHidden()
                } label: {
                    FilteredSearchScreenRow(
                        name: NSLocalizedString("media-filter-genre", comment: "Genre"),
                        isEmpty: filterVM.selectedGenres.isEmpty
                    )
                }
                VStack {
                    FilteredSearchScreenRow(
                        name: NSLocalizedString("media-filter-release", comment: "Release"),
                        isEmpty: filterVM.selectedYear == nil
                    )
                    ScrollYearFilter(selectedYear: $filterVM.selectedYear)
                }
                Spacer()
                Button {
                    print("Search with filters")
                } label: {
                    Text("media-filter-btn-search")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.capsuleButton)
            }
            .font(.hauora(size: 20))
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.bwg)
            .onAppear {
                Task {
                    await filterVM.getGenres(for: mediaType)
                }
            }
            .enableInjection()
        }
    }
    private func getResults() {
        Task {
            if mediaType == .movie {
                results = []
            } else {
                results = []
            }
        }
    }
}

struct FilteredSearchScreenRow: View {
    
    let name: String
    let isEmpty: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            Text(name)
            Image(systemName: "circle.fill")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 8)
                .foregroundStyle(isEmpty ? .bw50 : .blue1)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    NavigationStack {
        FilteredSearchScreen<Movie>(results: .constant([]) , mediaType: .movie)
    }
}
