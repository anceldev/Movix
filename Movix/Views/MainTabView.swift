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
            ProfileView()
                .environmentObject(viewModelAuth)
                .tabItem { Image("profile_dissabled") }
        }
#else
        TabView {
            if viewModelAuth.authenticationState == .authenticated {
                HomeView()
                    .tabItem { Image("home_dissabled") }
                SearchView()
                    .tabItem { Image(systemName: "search_dissabled")}
                ProfileView()
                    .environmentObject(viewModelAuth)
                    .tabItem { Image(systemName: "profile_dissabled") }
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
