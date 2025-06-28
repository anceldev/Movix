//
//  MainTabView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI
import Inject

enum MainTabOption {
    case home
    case search
    case movies
    case series
    case lists
    case profile
}

struct MainTabView: View {
    @State private var selectedTab: MainTabOption = .series
//    @Environment(UserViewModel.self) var userVM
    @State var userVM: UserViewModel
    @State private var seriesVM = SeriesViewModel()
    @State private var moviesVM = MoviesViewModel()
    
    @State private var navigationManager = NavigationManager()
    
    
    @ObserveInjection var forceRedraw

    init(user: User) {
        UITabBar.appearance().unselectedItemTintColor = .white
        self._userVM = State(initialValue: UserViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            TabView(selection: $navigationManager.activeTab) {
                HomeScreen()
                    .tag(MainTabOption.home)
                    .tabItem {
                        Label(
                            NSLocalizedString("home-tab-label", comment: "Home") ,
                            image: navigationManager.activeTab == .home ? "home-icon" : "home-icon-disabled"
                        )
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)

                SearchScreen()
                    .tag(MainTabOption.search)
                    .tabItem {
                        Label(
                            NSLocalizedString("search-tab-label", comment: "Search"),
                            systemImage: "magnifyingglass"
                        )
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
                
//                SeriesScreen()
//                    .tag(MainTabOption.series)
//                    .tabItem {
//                        Label(
//                            NSLocalizedString("series-tab-label", comment: "Series"),
//                            systemImage: navigationManager.activeTab == .series ? "tv" : "tv.fill"
//                        )
//                    }
//                    .toolbar(.visible, for: .tabBar)
//                    .toolbarBackground(.bw10, for: .tabBar)
//                
//                MoviesScreen()
//                    .tag(MainTabOption.movies)
//                    .tabItem {
//                        Label(
//                            NSLocalizedString("movies-tab-label", comment: "Movies") ,
//                            systemImage: navigationManager.activeTab == .movies ? "movieclapper.fill" : "movieclapper"
//                        )
//                    }
//                    .toolbar(.visible, for: .tabBar)
//                    .toolbarBackground(.bw10, for: .tabBar)
                
                MyListsScreen()
                    .tag(MainTabOption.lists)
                    .tabItem {
                        Label(
                            NSLocalizedString(
                                "lists-tab-label",
                                comment: "Lists"
                            ),
                            image: navigationManager.activeTab == .lists ? "heart-icon" :"heart-icon-disabled"
                        )
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
                
                ProfileScreen()
                    .tag(MainTabOption.profile)
                    .tabItem {
                        Label(NSLocalizedString("account-tab-label", comment: "Account"), image: navigationManager.activeTab == .profile ? "profile-icon" : "profil-icon-disabled")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(.bw10, for: .tabBar)
            }
            .withAppRouter()
            .tint(.blue1)
            .background(.bw10)
            .animation(.easeOut, value: navigationManager.activeTab)
            .toolbarBackground(.bw10, for: .tabBar)
            .onChange(of: navigationManager.activeTab) { _, newValue in
                navigationManager.path = []
                navigationManager.switchTab(to: newValue)
            }
        }
        .environment(navigationManager)
        .environment(userVM)
        .environment(seriesVM)
        .environment(moviesVM)
        .enableInjection()
    }
}

#Preview {
    MainTabView(user: PreviewData.user)
        .environment(Auth())
}
