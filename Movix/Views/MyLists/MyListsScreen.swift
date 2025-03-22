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
    @State private var selectedMedia: ListControlsMedia = .movies
    @State private var mediaPopover = false
    
    @Environment(NavigationManager.self) var navigationManager
    var body: some View {
        @Bindable var navigationManager = navigationManager
        NavigationStack(path: $navigationManager.path) {
            VStack(spacing: 0) {
                HStack {
                    Text("My \(selectedMedia.rawValue.capitalized)")
                        .foregroundStyle(.white)
                        .font(.hauora(size: 20, weight: .semibold))
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
                        VStack(spacing: 12) {
                            ForEach(ListControlsMedia.allCases) { btn in
                                Text(btn.rawValue.capitalized)
                                    .opacity(selectedMedia == btn ? 1 : 0.6)
                                    .onTapGesture {
                                        withAnimation(.easeIn) {
                                            selectedMedia = btn
                                            mediaPopover.toggle()
                                        }
                                    }
                                    .padding(.horizontal, 12)
                            }
                        }
                        .presentationCompactAdaptation(.popover)
                    }
                }
                Group {
                    if selectedMedia == .movies {
                        VStack {
                            CustomSegmentedControl(state: $selectedList)
                            switch selectedList {
                            case .favorites:
                                GridItemsView<Movie>(
                                    mediaItems: userVM.user.favoriteMovies,
                                    searchTerm: .constant(""),
                                    mediaType: .movie,
                                    columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ]
                                )
                            case .rates:
                                GridItemsView<Movie>(
                                    mediaItems: userVM.user.ratedMovies,
                                    searchTerm: .constant(""),
                                    mediaType: .movie,
                                    columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ]
                                )
                            }
                        }
                    }
                    else {
                        VStack {
                            CustomSegmentedControl(state: $selectedList)
                            switch selectedList {
                            case .favorites:
                                GridItemsView<TvSerie>(
                                    mediaItems: userVM.user.favoriteSeries,
                                    searchTerm: .constant(""),
                                    mediaType: .tv,
                                    columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                                )
                            case .rates:
                                GridItemsView<TvSerie>(
                                    mediaItems: userVM.user.ratedSeries,
                                    searchTerm: .constant(""),
                                    mediaType: .tv,
                                    columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                                )
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.bw10)
            .withAppRouter()
        }
    }
}

#Preview {
    MyListsScreen()
        .environment(UserViewModel(user: User.preview))
}
