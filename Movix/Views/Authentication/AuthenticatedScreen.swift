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
                MainTabView()
                    .environment(authVM)
                    .environment(UserViewModel(user: authVM.user!))
            case .authenticating:
                ProgressView()
                    .tint(.marsB)
            case .unauthenticated:
                AuthenticationScreen()
                    .environment(authVM)
            }
        }
    }
}

#Preview {
    AuthenticatedScreen()
}
