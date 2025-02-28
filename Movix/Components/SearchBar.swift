//
//  SearchBar.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI
import Combine

struct SearchBar: View {
    @Environment(MoviesViewModel.self) var moviesVM

    @Binding var searchTerm: String    
    var filterAction: () -> Void
    @Binding var viewOption: ViewOption
    
//    init(filterAction: @escaping () -> Void, viewOption: Binding<ViewOption>) {
//        self.filterAction = filterAction
//        self._itemsView = viewOption
//    }
    
    var body: some View {
        @Bindable var moviesVM = moviesVM
        HStack(spacing: 16) {
            HStack {
                Button {
                    searchMovies()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                        .padding(.leading, 12)
                        .padding(.trailing, 4)
                }
                TextField("Search...", text: $searchTerm, prompt: Text("Search...").foregroundStyle(.bw50))
                    .tint(Color.bw90)
                    .submitLabel(.search)
                    .onSubmit {
                        moviesVM.searchedMovies = []
                        searchMovies()
                    }
                
                Button(action: {
                    searchTerm = ""
                    moviesVM.searchedMovies = []
                }, label: {
                    Label("Clear", systemImage: "xmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.bw50)
                })
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .background(.bw40)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.leading, 16)
            //            .padding(.horizontal)
            HStack(spacing: 8) {
                Button(action: {
                    filterAction()
                }, label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.white)
                })
                Button(action: {
                    withAnimation(.easeInOut) {
                        viewOption = viewOption == .row ? .grid : .row
                    }
                }, label: {
                    Image(systemName: viewOption == .row ? "rectangle.grid.3x2" : "rectangle.grid.1x2")
                        .foregroundStyle(.white)
                })
            }
            .frame(height: 42)
            .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
    private func searchMovies() {
        Task {
            await moviesVM.searchMovies(searchTerm: searchTerm)
        }
    }
}
//
//#Preview(traits: .sizeThatFitsLayout, body: {
//    SearchBar(searchTerm: .constant(""), filterAction: {}, viewOption: .constant(.row))
//        .background(.bw20)
//})
