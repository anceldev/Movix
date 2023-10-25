//
//  AuthenticationView.swift
//  Movix
//
//  Created by Ancel Dev account on 25/10/23.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        VStack {
            switch viewModel.flow {
            case .login:
                Login()
                    .environmentObject(viewModel)
            case .signUp:
                SignUp()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationViewModel())
}
