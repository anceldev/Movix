//
//  ContentView.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State var userViewModel: UserViewModel
    
    init(uidUser: String) {
        self.userViewModel = UserViewModel(uidUser: uidUser)
    }
    
    var body: some View {
        TabView {
            HomeView()
                .mainTabView(image: "home_dissabled")
            SearchView()
                .mainTabView(image: "search_dissabled")
            ProfileView()
                .mainTabView(image: "profile_dissabled")
                .environment(userViewModel)
        }
        .tint(.cyanApp)
    }
}
#Preview {
    MainView(uidUser: "no user")
        .environmentObject(AuthenticationViewModel())
}
