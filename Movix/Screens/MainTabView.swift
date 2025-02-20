//
//  MainTabView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabOption = .home
    @State var moviesVM = MoviesViewModel()
    @State var userVM: UserViewModel
    
    init(user: User) {
        self._userVM = State(initialValue: UserViewModel(user: user))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                HomeScreen()
                    .tag(TabOption.home)
                    .tabItem {
                        Label("Home", image: .homeIcon)
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
                SearchScreen()
                    .tag(TabOption.search)
                    .tabItem {
                        Label("Search", image: .searchIcon)
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
                MyListsScreen()
                    .tag(TabOption.lists)
                    .tabItem {
                        Label("My Lists", image: .heartIcon)
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
                ProfileScreen()
                    .tag(TabOption.profile)
                    .tabItem {
                        Label("Profile", image: .profileIcon)
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
            }
        }
        .tint(.blue1)
        .background(.bw10)
        .environment(moviesVM)
        .environment(userVM)
        .animation(.easeOut, value: selectedTab)
        .toolbar(.visible, for: .tabBar)
        .toolbarBackground(.bw10, for: .tabBar)
    }
}

#Preview {
    MainTabView(user: User.preview)
        .environment(AuthViewModel())
}
