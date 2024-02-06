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

struct SignIn: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusedField?

    var body: some View {
        VStack {
            Spacer()
            VStack{
                VStack {
                    VStack {
                        Text("Hello,")
                        Text("Glad to see you!")
                    }
                    .font(.largeTitle)
                    Text("Your E-mail")
                        .padding(.top, 12)
                }
                .foregroundStyle(.semiWhite)
                VStack {
                    TextField(text: $viewModel.email) {
                        Text("Email")
                            .foregroundStyle(.grayLight)
                    }
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focus, equals: .email)
                    .onSubmit {
                        self.focus = .password
                    }
                    .buttonBorder(.grayLight)
                    
                    SecureField(text: $viewModel.password) {
                        Text("Password")
                            .foregroundStyle(.grayLight)
                    }
                    .autocorrectionDisabled()
                    .buttonBorder(.grayLight)
                    .focused($focus, equals: .password)
                    .onSubmit {
                        signInWithEmailPassword()
                    }
                    HStack {
                        Button(action: signInWithEmailPassword, label: {
                            if viewModel.authenticationState != .authenticating {
                                HStack {
                                    Spacer()
                                    Text("Login")
                                    Spacer()
                                }
                            }
                            else {
                                ProgressView()
                            }
                        })
                        .buttonFill()
                        .disabled(!viewModel.isValid)
                    }
                    VStack {
                        Text("Don't you have an account yet?")
                            .padding(.bottom)
                            .foregroundStyle(.white)
                        HStack {
                            Button(action: {
                                withAnimation {
                                    viewModel.switchFlow()
                                }
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text("Sign up")
                                    Spacer()
                                }
                            })
                            .buttonBorder(.semiWhite)
                        }
                    }
                }
                .padding()
            }
            .padding()
            Spacer()
            Spacer()
        }
        .foregroundStyle(.semiWhite)
        .background(.blackApp)
    }
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.singInWithEmailPassword() {
//                viewModel.fetchUserAccount(viewModel.user!.uid)
//                guard let userID = viewModel.user?.uid else {
//                    fatalError("Cannot identify user")
//                }
//                viewModel.fetchUserAccount(userID)
                dismiss() // If is signed, dismiss
            }
        }
    }
}

#Preview {
    SignIn()
        .environmentObject(AuthenticationViewModel())
}
