//
//  AuthenticationScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct AuthenticationScreen: View {
//    @Environment(AuthViewModel.self) var authVM
    var body: some View {
        VStack {
            Text("This is the authentication screen")
//            switch authVM.flow {
//            case .signIn:
//                SignInScreen()
//            case .signUp:
//                SignUpScreen()
//            }
        }
//        .environment(authVM)
    }
}

#Preview {
    AuthenticationScreen()
//        .environment(AuthViewModel())
}
