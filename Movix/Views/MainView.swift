//
//  ContentView.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModelAuth: AuthenticationViewModel
    var body: some View {
        TabView {
            if viewModelAuth.authenticationState == .authenticated {
                HomeView()
                    .tabItem { Image(systemName: "house") }
                ProfileView()
                    .environmentObject(viewModelAuth)
                    .tabItem { Image(systemName: "person") }
            }
            else {
                AuthenticationView()
                    .environmentObject(viewModelAuth)
            }
            
        }
        
    }
}
#Preview {
    MainView()
        .environmentObject(AuthenticationViewModel())
    
}
