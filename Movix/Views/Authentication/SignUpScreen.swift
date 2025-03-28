//
//  SignUpScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct SignUpScreen: View {
    private enum FocusedField {
        case name, email, password
    }
    
    @Environment(AuthViewModel.self) var authVM
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        @Bindable var authVM = authVM
        VStack {
            VStack(spacing: 28) {
                Title()
                    .padding(.top, 44)
                VStack(spacing: 16) {
                    TextField("Username", text: $authVM.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .customCapsule(focusedField == .name || name != "" ? .white : .bw50, input: true)
                        .foregroundStyle(email != "" ? .white : .bw50)
                        .focused($focusedField, equals: .name).animation(.easeInOut, value: focusedField)
                    
                    TextField("Email", text: $authVM.username)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .customCapsule(focusedField == .email || email != "" ? .white : .bw50, input: true)
                        .foregroundStyle(email != "" ? .white : .bw50)
                        .focused($focusedField, equals: .email).animation(.easeInOut, value: focusedField)
                    
                    SecureField("Password", text: $authVM.password)
                        .customCapsule(focusedField == .password || password != "" ? .white : .bw50, input: true)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password).animation(.easeInOut, value: focusedField)
                    
                    Button {
                        print("Sign up...")
                        signUp()
                    } label: {
                        Text("Sign up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.capsuleButton(.orangeGradient))
                    
                    VStack {
                        Text("By clicking the login button, you accept Privacy")
                        Text("Policy rules of our company")
                    }
                    .multilineTextAlignment(.center)
//                    .font(.system(size: 14))
                    .font(.hauora(size: 14))
                    .foregroundStyle(.bw50)
                    .padding(.top, 2)
                    VStack(spacing: 28) {
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(.white)
                                .frame(width: 60, height: 1)
                            Text("Or continue with")
                                .lineLimit(1)
                                .foregroundStyle(.white)
//                                .font(.system(size: 14))
                                .font(.hauora(size: 14))
                            Rectangle()
                                .fill(.white)
                                .frame(width: 60, height: 1)
                        }
                        HStack(spacing:38) {
                            Button(action: {
                                print("Google sign in...")
                            }, label: {
                                Image("googleSignIn")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            })
                            Button(action: {
                                print("Apple sign in...")
                            }, label: {
                                Image("appleSignIn")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            })
                        }
                    }
                    .padding(.horizontal, 40)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 27)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
    }
    
    @ViewBuilder
    private func Title() -> some View {
        VStack {
            VStack(spacing: 36) {
                Text("Login")
                    .font(.hauora(size: 34))
                VStack(spacing: 12) {
                    Image("profileDefault")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                    Text("Add your\navatar photo")
                        .multilineTextAlignment(.center)
                }
            }
            .foregroundStyle(.white)
        }
    }
    private func signUp() {
//        Task {
//            await authVM.signUp()
//        }
    }
}

#Preview {
    SignUpScreen()
        .environment(AuthViewModel())
}
