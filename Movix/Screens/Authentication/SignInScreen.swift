//
//  SignInScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct SignInScreen: View {
    private enum FocusedField {
        case username, password
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
                    TextField("Email", text: $authVM.username)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .customCapsule(focusedField == .username || authVM.username != "" ? .white : .bw50, input: true)
                        .foregroundStyle(authVM.username != "" ? .white : .bw50)
                        .focused($focusedField, equals: .username).animation(.easeInOut, value: focusedField)
                        .tint(.white)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                    SecureField("Password", text: $authVM.password)
                        .customCapsule(focusedField == .password || authVM.password != "" ? .white : .bw50, input: true)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password).animation(.easeInOut, value: focusedField)
                        .tint(.white)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                    Button(action: {
                        login()
                    }, label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.capsuleButton(.orangeGradient))
                    .disabled(authVM.state == .authenticating)
                    VStack {
                        Text("By clicking the login button, you accept our")
                        Button {
                            showPrivacyRules.toggle()
                        } label: {
                            Text("privacy policy rules.")
                                .underline()
                        }
                    }
                    .multilineTextAlignment(.center)
                    .font(.hauora(size: 14))
                    .foregroundStyle(.bw50)
                    .padding(.top, 2)
                    Spacer()
                    VStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.bw50)
                            .font(.hauora(size: 16))
                        Link(destination: URL(string: "https://www.themoviedb.org/signup")!) {
                            Text("Join TMDB")
                                .foregroundStyle(.blue1)
                        }
                    }
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
                Text("Login")
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
