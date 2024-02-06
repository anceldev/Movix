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
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: FocusedField?
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                VStack {
                    Text("Sign Up")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                    Image("avatarDefault")
                        .resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .padding(.top)
                    VStack {
                        Text("Add your\navatar photo")
                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.semiWhite)
                    }
                    .padding([.top, .bottom])
                }
                TextField(text: $authViewModel.email){
                    Text("Email")
                        .foregroundStyle(.grayLight)
                    
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focus, equals: .email)
                .onSubmit {
                    // code to do on submit email
                    self.focus = .password
                }
                .foregroundStyle(authViewModel.email.isEmpty ? .grayLight : .semiWhite)
                .buttonBorder(.grayLight)
                SecureField(text: $authViewModel.password){
                    Text("Password")
                        .foregroundStyle(.grayLight)
                }
                .autocorrectionDisabled()
                .foregroundStyle(authViewModel.password.isEmpty ? .grayLight : .semiWhite)
                .focused($focus, equals: .password)
                .onSubmit {
                    focus = .confirmPassword
                }
                .buttonBorder(.grayLight)
                SecureField(text: $authViewModel.confirmPassword){
                    Text("Confirm password")
                        .foregroundStyle(.grayLight)
                    
                }
                .autocorrectionDisabled()
                .foregroundStyle(authViewModel.confirmPassword.isEmpty ? .grayLight : .white)
                .focused($focus, equals: .confirmPassword)
                .onSubmit {
                    signUpWithEmailPassword()
                }
                .buttonBorder(.grayLight)
                Button(action: signUpWithEmailPassword, label: {
                    if authViewModel.authenticationState != .authenticating {
                        Spacer()
                        Text("Sign up")
                        Spacer()
                    }
                    else {
                        ProgressView()
                    }
                    
                })
                .buttonFill()
                .disabled(!authViewModel.isValid)
                .padding(.top)
                VStack {
                    Text("Already have an account?").foregroundStyle(.semiWhite)
                    Button(action: {
                        withAnimation {
                            authViewModel.switchFlow()
                        }
                    }, label: {
                        Text("Log in").foregroundStyle(.white).bold()
                    })
                }
            }
            .padding()
            Spacer()
            Spacer()
            Spacer()
        }
        .padding()
        .background(.blackApp)
    }
    private func signUpWithEmailPassword(){
        Task {
            if await authViewModel.signUpWithEmailPassword() {
                let newAccount = User(id: authViewModel.user?.uid , name: "username", email: authViewModel.email, friends: [], history: [])
                do {
                    try await authViewModel.createDocument(for: newAccount)
                    dismiss()
                } catch {
                    fatalError("Cannot create firestore user document account")
                }
            }
        }
    }
}

#Preview {
    SignUp()
        .environmentObject(AuthenticationViewModel())
    //.environmentObject(AccountViewModel())
}
