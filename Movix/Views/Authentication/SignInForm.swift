//
//  SignInForm.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI
import AuthenticationServices

struct SignInForm: View {
    private enum FocusedField {
        case email, password
    }
    
    @Environment(Auth.self) var authVM
    @FocusState private var focusedField: FocusedField?
    @State private var showPrivacyRules = false
    
    @Binding var flow: AuthFlow
    let action: (String, String) async -> Void
    
    @State private var authenticating = false
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        @Bindable var authVM = authVM
        VStack {
            VStack(spacing: 28) {
                VStack(spacing: 16) {
                    TextField("login-email-label", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .customCapsule(focusedField == .email || email != "" ? .white : .bw50, input: true)
                        .foregroundStyle(email != "" ? .white : .bw50)
                        .focused($focusedField, equals: .email).animation(.easeInOut, value: focusedField)
                        .tint(.white)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                    
                    SecureField("login-password-label", text: $password)
                        .customCapsule(focusedField == .password || password != "" ? .white : .bw50, input: true)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password).animation(.easeInOut, value: focusedField)
                        .tint(.white)
                        .submitLabel(.go)
                        .onSubmit {
                            focusedField = nil
                        }
                    Button(action: {
                        authenticating = true
                        Task {
                            await action(email, password)
                            authenticating = false
                        }

                    }, label: {
                        Text("login-submit-button-label")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.capsuleButton(.orangeGradient))
                    .disabled(authenticating)
                    
                    if let errorMessage = authVM.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
//                    SignInWithAppleButton { request in
//                        
//                    } onCompletion: { result in
//                        
//                    }
//                    .signInWithAppleButtonStyle(.black)
//                    SignInWithAppleButton(.continue) { request in
//                        
//                    } onCompletion: { respose in
//                        
//                    }
//                    .frame(width: 100, height: 100)
//                    .clipShape(.circle)

                    HStack(spacing: 4) {
                        Text("login-question-signin")
                            .foregroundStyle(.white)
                        Button(action: {
                            withAnimation(.easeIn) {
                                flow = .signUp
                            }
                        }, label: {
                            Text("login-question-link-signup")
                                .foregroundStyle(.blue1)
                        })
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
                }
                Spacer()
            }
            .padding(.horizontal, 27)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showPrivacyRules) {
            PrivacyScreen()
                .presentationDetents([.height(.infinity)])
        }
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    @Previewable @State var preview = Auth()
    NavigationStack {
        SignInForm(flow: .constant(.signIn),action: {_,_ in })
            .environment(preview)
    }
})
