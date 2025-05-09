//
//  AuthenticationScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct AuthenticationScreen: View {
    @Environment(AuthViewModel.self) var authVM
    var body: some View {
        VStack {
            switch authVM.flow {
            case .signIn:
                SignInForm()
            case .signUp:
                SignUpForm()
            case .preferences:
                ProfileForm()
            }
        }
        .environment(authVM)
    }
}

#Preview {
    AuthenticationScreen()
        .environment(AuthViewModel())
}
