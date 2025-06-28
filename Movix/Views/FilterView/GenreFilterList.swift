//
//  GenreFilterList.swift
//  Movix
//
//  Created by Ancel Dev account on 15/5/25.
//

import SwiftUI

struct GenreFilterList: View {
    @Environment(\.dismiss) var dismiss
    @Environment(FilterViewModel.self) var filterVM
    var genres: [Genre]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(filterVM.selectedGenres) { selected in
                            Button {
                                withAnimation(.easeIn) {
                                    filterVM.toggleSelectedGenre(selected)
                                }
                            } label: {
                                Text(selected.name)
                                    .font(.hauora(size: 18))
                                    .foregroundStyle(.white)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(.bw40)
                            .clipShape(.capsule)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .frame(maxWidth: .infinity)
            ScrollView(.vertical) {
                ForEach(genres) { genre in
                    GenreListRow(genre: genre)
                    Divider()
                        .frame(height: 2)
                        .background(.bw40)
                        .opacity(0.5)
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bwg)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    BackButton()
                }
            }
        }
    }
}

struct GenreListRow: View {
    @Environment(FilterViewModel.self) var filterVM
    var genre: Genre
    var body: some View {
        Button {
            withAnimation(.easeIn) {
                filterVM.toggleSelectedGenre(genre)
            }
        } label: {
            HStack {
                Text(genre.name)
                    .font(.hauora(size: 16))
                Spacer()
                Image(.done)
                    .opacity(filterVM.selectedGenres.contains { $0.id == genre.id } ? 1 : 0)
                    .foregroundStyle(.blue1)
                    .padding(.trailing, 8)
            }
        }
        .foregroundStyle(.white)
    }
}
