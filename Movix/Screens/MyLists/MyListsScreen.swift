//
//  MyListsScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

enum ListControls: String, CaseIterable, Identifiable, Hashable {
    case favorites
    case rates
    var id: Self { self }
}

struct MyListsScreen: View {
    @Environment(UserViewModel.self) var userVM
    @State private var selectedControl: ListControls = .favorites
    var body: some View {
        NavigationStack {
            VStack {
                Text("My Lists")
                    .font(.hauora(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                CustomSegmentedControl(state: $selectedControl)
                VStack {
                    switch selectedControl {
                    case .favorites:
                        FavoritesListView(movies: userVM.user.favoriteMovies)
                    case .rates:
                        RatesListView(ratedList: userVM.user.ratedMovies)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.bw10)
        }
    }
}

#Preview {
    MyListsScreen()
        .environment(UserViewModel(user: User.preview))
}
