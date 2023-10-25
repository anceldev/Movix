//
//  Login.swift
//  Movix
//
//  Created by Ancel Dev account on 24/10/23.
//

import SwiftUI

private enum FocusedField: Hashable {
    case email
    case password
}

struct Login: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusedField?
    
    @State var email = ""
    @State var password = ""
    
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.singInWithEmailPassword() {
                dismiss() // If is signed, dismiss
            }
        }
    }
    
    var body: some View {
        VStack{
            Text("Hello,")
            Text("Glad to see you!")
            Text("Your E-mail or phone number")
            VStack {
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focus, equals: .email)
                    .onSubmit {
                        self.focus = .password
                    }
                SecureField("Password", text: $viewModel.password)
                    .focused($focus, equals: .password)
                    .onSubmit {
                        signInWithEmailPassword()
                    }
            }
        }
        HStack {
            Button(action: signInWithEmailPassword, label: {
                if viewModel.authenticationState != .authenticating {
                    Text("Login")
                }
                else {
                    ProgressView()
                }
                
            })
            .disabled(!viewModel.isValid)
        }
        HStack {
            Text("Dont you have an account yet?")
            Button(action: {
                viewModel.switchFlow()
            }, label: {
                Text("Sign up")
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
            })
        }
    }
}

#Preview {
    Login()
        .environmentObject(AuthenticationViewModel())
}
