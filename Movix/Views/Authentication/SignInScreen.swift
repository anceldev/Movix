//
//  SignInScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct SignInScreen: View {
    private enum FocusedField {
        case email, password
    }
    
    @Environment(AuthViewModel.self) var authVM
    @FocusState private var focusedField: FocusedField?
    @State private var showPrivacyRules = false
    
    var body: some View {
        @Bindable var authVM = authVM
        VStack {
            VStack(spacing: 28) {
                Title()
                    .padding(.top, 44)
                VStack(spacing: 16) {
                    TextField("login-email-label", text: $authVM.email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .customCapsule(focusedField == .email || authVM.email != "" ? .white : .bw50, input: true)
                        .foregroundStyle(authVM.username != "" ? .white : .bw50)
                        .focused($focusedField, equals: .email).animation(.easeInOut, value: focusedField)
                        .tint(.white)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                    
                    SecureField("login-password-label", text: $authVM.password)
                        .customCapsule(focusedField == .password || authVM.password != "" ? .white : .bw50, input: true)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password).animation(.easeInOut, value: focusedField)
                        .tint(.white)
                        .submitLabel(.go)
                        .onSubmit {
                            focusedField = nil
                            login()
                        }
                    Button(action: {
                        login()
                    }, label: {
                        Text("login-submit-button-label")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.capsuleButton(.orangeGradient))
                    .disabled(authVM.state == .authenticating)
                    
                    if let errorMessage = authVM.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    
                    HStack(spacing: 4) {
                        Text("login-question-signin")
                            .foregroundStyle(.white)
                        Button(action: {
                            withAnimation(.easeIn) {
                                authVM.flow = .signUp
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
        .background(.bw10)
        .sheet(isPresented: $showPrivacyRules) {
            PrivacyScreen()
                .presentationDetents([.height(.infinity)])
        }
    }
    
    @ViewBuilder
    private func Title() -> some View {
        VStack {
            VStack(spacing: 36) {
                Text("login-signin-title")
                    .font(.hauora(size: 34))
                VStack(spacing: 12) {
                    Image("profileDefault")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                }
                .padding(.bottom, 24)
            }
            .foregroundStyle(.white)
        }
    }
    
    private func login() {
        Task {
            authVM.errorMessage = nil
            await authVM.signIn()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    @Previewable @State var preview = AuthViewModel()
    return NavigationStack {
        SignInScreen()
            .environment(preview)
    }
})
