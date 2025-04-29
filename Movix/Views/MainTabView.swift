//
//  MainTabView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTabOption = .series
    @Environment(UserViewModel.self) var userVM
    @State private var seriesVM = SeriesViewModel()
    @State private var navigationManager = NavigationManager()

    init() {
        UITabBar.appearance().unselectedItemTintColor = .white
    }
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            TabView(selection: $navigationManager.activeTab) {
                HomeScreen()
                    .tag(MainTabOption.home)
                    .tabItem {
                        Label(NSLocalizedString("home-tab-label", comment: "Home") , systemImage: "house.fill")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
                
                SeriesScreen()
                    .tag(MainTabOption.series)
                    .tabItem {
                        Label(NSLocalizedString("series-tab-label", comment: "Series"), systemImage: selectedTab == .series ? "tv" : "tv.fill")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
                
                MoviesScreen()
                    .tag(MainTabOption.movies)
                    .tabItem {
                        Label(NSLocalizedString("movies-tab-label", comment: "Movies") , systemImage: selectedTab == .movies ? "movieclapper.fill" : "movieclapper")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
                
                MyListsScreen()
                    .tag(MainTabOption.lists)
                    .tabItem {
                        Label(NSLocalizedString("lists-tab-label", comment: "Lists"), systemImage: "heart.fill")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
                
                ProfileScreen()
                    .tag(MainTabOption.profile)
                    .tabItem {
                        Label(NSLocalizedString("account-tab-label", comment: "Account"), systemImage: selectedTab == .profile ? "person" : "person.fill")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
            }
            .withAppRouter()
            .tint(.blue1)
            .background(.bw10)
            .animation(.easeOut, value: selectedTab)
            .toolbar(.visible, for: .tabBar)
            .toolbarBackground(.bw10, for: .tabBar)
            .onChange(of: navigationManager.activeTab) { _, newValue in
                navigationManager.path = []
                navigationManager.switchTab(to: newValue)
            }
        }
        .environment(navigationManager)
        .environment(userVM)
    }
}

#Preview {
    MainTabView()
        .environment(AuthViewModel())
        .environment(UserViewModel(user: PreviewData.user ))
}
