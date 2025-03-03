//
//  MainTabView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabOption = .series
    @State var moviesVM = MoviesViewModel()
    @State var userVM: UserViewModel
    @State private var seriesVM = SeriesViewModel()
    
    init(user: User) {
        self._userVM = State(initialValue: UserViewModel(user: user))
        UITabBar.appearance().unselectedItemTintColor = .white
//        UITabBar.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tag(TabOption.home)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(.bw10, for: .tabBar)
            SeriesScreen()
                .tag(TabOption.series)
                .tabItem {
                    Label("Series", systemImage: selectedTab == .series ? "tv" : "tv.fill")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(.bw10, for: .tabBar)
            
            MoviesScreen()
                .tag(TabOption.movies)
                .tabItem {
                    Label("Movies", systemImage: selectedTab == .movies ? "movieclapper.fill" : "movieclapper")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(.bw10, for: .tabBar)
            
            MyListsScreen()
                .tag(TabOption.lists)
                .tabItem {
                    Label("My lists", systemImage: "heart.fill")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(.bw10, for: .tabBar)
            ProfileScreen()
                .tag(TabOption.profile)
                .tabItem {
                    Label("Profile", systemImage: selectedTab == .profile ? "person" : "person.fill")
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(.bw10, for: .tabBar)
        }
        .tint(.blue1)
        .background(.bw10)
        .environment(moviesVM)
        .environment(userVM)
        .environment(seriesVM)
        .animation(.easeOut, value: selectedTab)
        .toolbar(.visible, for: .tabBar)
        .toolbarBackground(.bw10, for: .tabBar)
    }
}

#Preview {
    MainTabView(user: User.preview)
        .environment(AuthViewModel())
}
