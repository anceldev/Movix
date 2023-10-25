//
//  SignUp.swift
//  Movix
//
//  Created by Ancel Dev account on 25/10/23.
//

import SwiftUI

private enum FocusedField: Hashable {
    case email
    case password
    case confirmPassword
}

struct SignUp: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusedField?
    
    private func signUpWithEmailPassword(){
        Task {
            if await viewModel.signUpWithEmailPassword() {
                //
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.title)
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focus, equals: .email)
                .onSubmit {
                    // code to do on submit email
                    self.focus = .password
                }
            SecureField("Password", text: $viewModel.password)
                .focused($focus, equals: .password)
                .onSubmit {
                    focus = .confirmPassword
                }
            SecureField("Confirm password", text: $viewModel.confirmPassword)
                .focused($focus, equals: .confirmPassword)
                .onSubmit {
                    signUpWithEmailPassword()
                }
        }
        .padding()
        VStack{
            HStack{
                Button(action: signUpWithEmailPassword, label: {
                    //
                    if viewModel.authenticationState != .authenticating {
                        Text("Sign up")
                    }
                    else {
                        ProgressView()
                    }
                        
                })
                .disabled(!viewModel.isValid)
            }
            HStack {
                Text("Already have an account?")
                Button(action: { viewModel.switchFlow() }, label: {
                    Text("Log in")
                })
            }
        }
    }
}

#Preview {
    SignUp()
        .environmentObject(AuthenticationViewModel())
}
