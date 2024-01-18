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
        TabView {
            HomeView()
                .tabItem { Image("home_dissabled") }
            SearchView()
                .tabItem { Image("search_dissabled") }
                .toolbarBackground(Color.blackApp, for: .tabBar)
            ProfileView()
                .tabItem { Image("profile_dissabled") }
        }
        .background(.blackApp)
    }
}
#Preview {
    MainTabView()
        .environmentObject(AuthenticationViewModel())
}
