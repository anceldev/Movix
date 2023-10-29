//
//  AuthenticationView.swift
//  Movix
//
//  Created by Ancel Dev account on 25/10/23.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    var body: some View {
        VStack {
            switch viewModel.flow {
            case .login:
                Login()
                    .environmentObject(viewModel)
                    .environmentObject(accountViewModel)
            case .signUp:
                SignUp()
                    .environmentObject(viewModel)
                    .environmentObject(accountViewModel)
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(AccountViewModel())
}
