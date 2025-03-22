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
                MainTabView(user: authVM.user!)
                    .environment(authVM)
            case .authenticating:
                ProgressView()
                    .tint(.marsB)
            case .unauthenticated:
                SignInScreen()
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
