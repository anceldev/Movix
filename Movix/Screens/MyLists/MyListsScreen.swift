//
//  MyListsScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI


enum ListControlsMedia: String, CaseIterable, Identifiable, Hashable {
    case movies
    case series
    var id: Self { self }
}


enum ListControls: String, CaseIterable, Identifiable, Hashable {
    case favorites
    case rates
    var id: Self { self }
}

struct MyListsScreen: View {
    @Environment(UserViewModel.self) var userVM
    @State private var selectedList: ListControls = .favorites
//    @State private var selectedControlMedia: ListControlsMedia = .movies
    @State private var selectedMedia: ListControlsMedia = .movies
    @State private var mediaPopover = false
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("My lists")
                        .font(.hauora(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        mediaPopover.toggle()
                    } label: {
                        Text(selectedMedia.rawValue.capitalized)
                            .font(.hauora(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(.bw40)
                            .clipShape(.capsule)
                    }
                    .popover(isPresented: $mediaPopover) {
                        VStack {
                            ForEach(ListControlsMedia.allCases) { btn in
                                Text(btn.rawValue.capitalized)
                                    .onTapGesture {
                                        withAnimation(.easeIn) {
                                            selectedMedia = btn
                                        }
                                    }
                            }
                        }
                        .presentationCompactAdaptation(.popover)
                    }
                }
                VStack {
                    CustomSegmentedControl(state: $selectedList)
                    switch selectedList {
                    case .favorites:
                        FavoritesListView<Movie>(mediaItems: userVM.user.favoriteMovies)
                    case .rates:
                        RatesListView(ratedList: userVM.user.ratedMovies)
                    }
                }
                Spacer()
                
//                Text("My Lists")
//                    .font(.hauora(size: 22, weight: .semibold))
//                    .foregroundStyle(.white)
//                CustomSegmentedControl(state: $selectedControlMedia)
//                
//                VStack {
//                    switch selectedControl {
//                    case .favorites:
//                        FavoritesListView(movies: userVM.user.favoriteMovies)
//                    case .rates:
//                        RatesListView(ratedList: userVM.user.ratedMovies)
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal, 16)
//                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.bw10)
        }
    }
}

#Preview {
    MyListsScreen()
        .environment(UserViewModel(user: User.preview))
}
