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
                            .foregroundStyle(.blackWhite)
                    }
                    .padding([.top, .bottom])
                }
                TextField(text: $viewModel.email){
                    Text("Email")
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundStyle(.textGray)
                        .focused($focus, equals: .email)
                        .onSubmit {
                            // code to do on submit email
                            self.focus = .password
                        }
                }
                .buttonBorder(.textGray)
                SecureField(text: $viewModel.password){
                    Text("Password")
                        .foregroundStyle(.textGray)
                }
                .focused($focus, equals: .password)
                .onSubmit {
                    focus = .confirmPassword
                }
                .buttonBorder(.textGray)
                SecureField(text: $viewModel.confirmPassword){
                    Text("Confirm password")
                        .foregroundStyle(.textGray)
                }
                .focused($focus, equals: .confirmPassword)
                .onSubmit {
                    signUpWithEmailPassword()
                }
                .buttonBorder(.textGray)
                HStack{
                    Button(action: signUpWithEmailPassword, label: {
                        //
                        if viewModel.authenticationState != .authenticating {
                            Spacer()
                            Text("Sign up")
                            Spacer()
                        }
                        else {
                            ProgressView()
                        }
                        
                    })
                    .buttonFill()
                    .disabled(!viewModel.isValid)
                    
                }
                .padding(.top)
                VStack {
                    Text("Already have an account?").foregroundStyle(.textGray)
                    Button(action: {
                        withAnimation {
                            viewModel.switchFlow()
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
}

#Preview {
    SignUp()
        .environmentObject(AuthenticationViewModel())
}
