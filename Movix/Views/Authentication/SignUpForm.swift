//
//  SignUpForm.swift
//  Movix
//
//  Created by Ancel Dev account on 7/5/25.
//

import SwiftUI

struct SignUpForm: View {
    private enum FocusedField {
        case username, email, password
    }
    
    @Environment(Auth.self) var authVM
    @FocusState private var focusedField: FocusedField?
    @State private var showPrivacyRules = false
    
    @Binding var flow: AuthFlow
    @State private var email = ""
    @State private var password = ""
    
    let action: (String, String) async -> Void
    
    var body: some View {
        @Bindable var authVM = authVM
        VStack(spacing: 28) {
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .customCapsule(focusedField == .email || email != "" ? .white : .bw50, input: true)
                    .foregroundStyle(email != "" ? .white : .bw50)
                    .focused($focusedField, equals: .email).animation(.easeInOut, value: focusedField)
                    .onSubmit { focusedField = .password }
                    .submitLabel(.next)
                
                SecureField("Password", text: $password)
                    .customCapsule(focusedField == .password || password != "" ? .white : .bw50, input: true)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .password).animation(.easeInOut, value: focusedField)
                    .onSubmit { focusedField = nil }
                    .submitLabel(.go)
                
                Button {
                    focusedField = nil
                    Task {
                        await action(email, password)
                    }
                } label: {
                    Text("login-signup-title")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.capsuleButton(.orangeGradient))
                
                HStack {
                    Text("login-question-signup")
                        .foregroundStyle(.white)
                    Button {
                        withAnimation(.easeIn) {
                            flow = .signIn
                        }
                    } label: {
                        Text("login-question-link-signin")
                            .foregroundStyle(.blue1)
                    }
                }
                .font(.hauora(size: 14))
                VStack {
                    Text("login-privacy-link-label")
                    Button {
                        showPrivacyRules.toggle()
                    } label: {
                        Text("login-privacy-link")
                            .underline()
                    }
                }
                .multilineTextAlignment(.center)
                .font(.hauora(size: 12))
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
        .background(.bw10)
        .sheet(isPresented: $showPrivacyRules) {
            PrivacyScreen()
                .presentationDetents([.height(.infinity)])
        }
    }
}
