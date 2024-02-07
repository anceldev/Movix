//
//  AuthenticatedView.swift
//  Movix
//
//  Created by Ancel Dev account on 25/10/23.
//

import SwiftUI

struct AuthenticatedView: View {
        
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            NavigationStack {
                switch authViewModel.authenticationState {
                case .unauthenticated, .authenticating:
                    AuthenticationView()
                        .environmentObject(authViewModel)
                case .authenticated:
                    MainView(uidUser: authViewModel.user!.uid)
                        .environmentObject(authViewModel)
                }
            }
        }
        .background(Color.blackApp)
    }
}

#Preview {
    AuthenticatedView()
        .environmentObject(AuthenticationViewModel())
}
