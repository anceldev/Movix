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
                    TextField("Email", text: $authVM.email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .customCapsule(focusedField == .username || authVM.email != "" ? .white : .bw50, input: true)
                        .foregroundStyle(authVM.email != "" ? .white : .bw50)
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
                    .font(.system(size: 14))
                    .foregroundStyle(.bw50)
                    .padding(.top, 2)
                    Spacer()
                    VStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.bw50)
                            .font(.system(size: 16))
//                        Link("Join TMDB", destination: URL(string: "https://www.themoviedb.org/signup")!)
//                            .foregroundStyle(.blue1)
                        Button {
                            withAnimation(.easeIn) {
                                authVM.flow = .signUp
                            }
                        } label: {
                            Text("Sign up")
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
        }
    }
    
    @ViewBuilder
    private func Title() -> some View {
        VStack {
            VStack(spacing: 36) {
                Text("Login")
                    .font(.system(size: 34))
                VStack(spacing: 12) {
                    Image("profileDefault")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
//                    Text("Add your\navatar")
//                        .multilineTextAlignment(.center)
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
//    preview.account?.id = 1
//    preview.account?.name = "Name"
//    preview.account?.username = "Username"
    return NavigationStack {
        SignInScreen()
            .environment(preview)
    }
})
