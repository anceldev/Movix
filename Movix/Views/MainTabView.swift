//
//  ContentView.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModelAuth: AuthenticationViewModel
    var body: some View {
#if DEBUG
        TabView {
            HomeView()
                .tabItem { Image("home_dissabled") }
            SearchView()
                .tabItem { Image("search_dissabled") }
                .toolbarBackground(Color.blackApp, for: .tabBar)
            ProfileView()
                .environmentObject(viewModelAuth)
                .tabItem { Image("profile_dissabled") }
        }
        .background(.blackApp)
#else
        TabView {
            if viewModelAuth.authenticationState == .authenticated {
                    HomeView()
                        .tabItem { Image("home_dissabled") }
                        .toolbarBackground(Color.blackApp, for: .tabBar)
                    SearchView()
                        .tabItem { Image(systemName: "search_dissabled")}
                        .toolbarBackground(Color.blackApp, for: .tabBar)
                    ProfileView()
                        .environmentObject(viewModelAuth)
                        .tabItem { Image(systemName: "profile_dissabled") }
                        .toolbarBackground(Color.blackApp, for: .tabBar)

            }
            else {
                AuthenticationView()
                    .environmentObject(viewModelAuth)
            }
        }
        .background(.blackApp)
#endif
    }
}
#Preview {
    MainTabView()
        .environmentObject(AuthenticationViewModel())
}
