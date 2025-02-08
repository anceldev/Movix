//
//  AuthenticatedScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct AuthenticatedScreen: View {
    @State var authVM = AuthViewModel()
    var body: some View {
        VStack {
            switch authVM.state {
            case .authenticated:
                if let user = authVM.user {
                    MainTabView(user: user)
                        .environment(authVM)
                }
                else {
                    VStack {
                        Text("Error getting account")
                    }
                }
//                MainTabView()
//                    .environment(authVM)
            case .authenticating:
                ProgressView()
                    .tint(.marsB)
            case .unauthenticated:
                AuthenticationScreen()
                    .environment(authVM)
            }
        }
    }
    private func signOut() {
        Task {
            await authVM.signOut()
        }
    }
}

#Preview {
    AuthenticatedScreen()
}
