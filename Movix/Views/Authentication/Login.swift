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
    @EnvironmentObject var accountViewModel: AccountViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusedField?
    
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.singInWithEmailPassword() {
                accountViewModel.fetchUserAccount(viewModel.user!.uid)
                dismiss() // If is signed, dismiss
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack{
                VStack {
                    Text("Hello,")
                    Text("Glad to see you!")
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                
                Text("Your E-mail or phone number")
                    .foregroundStyle(.blackWhite)
                VStack {
                    
                    TextField(text: $viewModel.email) {
                        Text("Email")
                            .foregroundStyle(.textGray)
                    }
                    .foregroundStyle(viewModel.email.isEmpty ? .textGray : .blackWhite)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focus, equals: .email)
                    .onSubmit {
                        self.focus = .password
                    }
                    .buttonBorder(.textGray)
                    SecureField(text: $viewModel.password) {
                        Text("Password")
                            .foregroundStyle(.textGray)
                    }
                    .foregroundStyle(viewModel.password.isEmpty ? .textGray : .blackWhite)
                    .autocorrectionDisabled()
                    .buttonBorder(.textGray)
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
                                        .foregroundStyle(.blackWhite)
                                    Spacer()
                                }
                            })
                            .buttonBorder(.blackWhite)
                        }
                    }
                }
                .padding()
            }
            .padding()
            Spacer()
            Spacer()
        }
        .background(.blackApp)
    }
}

#Preview {
    Login()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(AccountViewModel())
}
