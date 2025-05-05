//
//  MyListsScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation
import SwiftUI

enum ListControlsMedia: String, CaseIterable, Identifiable, Hashable {
    case movies
    case series
    
    var id: Self { self }
    var localizedTitle: String {
        switch self {
        case .movies:
            return NSLocalizedString("movies-tab-label", comment: "Movies")
        case .series:
            return NSLocalizedString("series-tab-label", comment: "Series")
        }
    }
}
protocol Localizable {
    var localizedTitle: String { get }
}

enum ListControls: String, CaseIterable, Identifiable, Hashable, Localizable {
    case favorites
    case rates
    case lists
    var id: Self { self }
    
    var localizedTitle: String {
        switch self {
        case .favorites:
            return NSLocalizedString("movie-list-controls-favorites", comment: "Favorites")
        case .rates:
            return NSLocalizedString("movie-list-controls-rated", comment: "Rated")
        case  .lists:
            return NSLocalizedString("custom-lists-tab-label", comment: "Lists")
        }
    }
}

struct MyListsScreen: View {
    @Environment(UserViewModel.self) var userVM
    @State private var selectedList: ListControls = .favorites
    @State private var selectedMedia: ListControlsMedia = .movies
    @State private var mediaPopover = false
    @State private var showNewList = false
    
    @Environment(NavigationManager.self) var navigationManager
    var body: some View {
        VStack(spacing: 0) {
            Text("lists-tab-label")
                .font(.hauora(size: 22, weight: .semibold))
                .foregroundStyle(.white)
            VStack(spacing: 8) {
                HStack {
                    Spacer()
                    Button {
                        mediaPopover.toggle()
                    } label: {
                        Text(selectedMedia.localizedTitle)
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
                                Text(btn.localizedTitle)
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
                    Button {
                        showNewList.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                    }
                    .padding(5)
                    .background(.bw40)
                    .clipShape(.circle)
                }
            }
            Group {
                if selectedMedia == .movies {
                    VStack {
                        CustomSegmentedControl(state: $selectedList)
                        switch selectedList {
                        case .favorites:
                            GridItemsView3<TestUserMovie>(
                                mediaItems: userVM.user.movies.filter({ $0.isFavorite }),
                                mediaType: .movie,
                                columns: 3
                            )
                        case .rates:
                            GridItemsView3<TestUserMovie>(
                                mediaItems: userVM.user.movies.filter({ $0.rating != nil }),
                                mediaType: .movie,
                                columns: 3
                            )
                        case .lists:
                            CustomMediaListsView(list: userVM.user.lists.filter({ $0.listType == .movie }))
                        }
                    }
                }
                else {
                    VStack {
                        CustomSegmentedControl(state: $selectedList)
                        switch selectedList {
                        case .favorites:
                            GridItemsView3<TestUserSerie>(
                                mediaItems: userVM.user.series.filter({ $0.isFavorite }),
                                mediaType: .tv,
                                columns: 3
                            )
                        case .rates:
                            GridItemsView3<TestUserSerie>(
                                mediaItems: userVM.user.series.filter({ $0.rating != nil }),
                                mediaType: .tv,
                                columns: 3
                            )
                        case .lists:
                            Text("My series lists")
                        }
                    }
                }
            }
            Spacer()
        }
        .padding([.horizontal, .bottom])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .withAppRouter()
        .environment(userVM)
        .sheet(isPresented: $showNewList) {
            NewListView()
                .presentationDetents([.medium])
//                .environment(userVM)
        }
    }
}

#Preview {
    MyListsScreen()
        .environment(UserViewModel(user: PreviewData.user))
        .environment(NavigationManager())
}
