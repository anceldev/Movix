//
//  AuthenticationScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct AuthenticationScreen: View {
    
    @Environment(Auth.self) var authVM
    @Binding var authState: AuthState
    @State var flow: AuthFlow = .signIn
    @State private var avatar: UIImage?
    
    var body: some View {
        VStack {
            VStack(spacing: 28) {
                VStack(spacing: 36) {
                    Text(flow.localizedTitle)
                        .font(.hauora(size: 34))
                    AvatarField(avatar: $avatar, flow: flow)
                        .padding(.bottom, 24)
                }
                .foregroundStyle(.white)
            }
            .padding(.top, 44)
            
            switch flow {
            case .signIn:
                SignInForm(flow: $flow, action: signIn)
            case .signUp:
                SignUpForm(flow: $flow, action: signUp)
            case .preferences:
                ProfileForm(avatar: $avatar, action: updateProfile)
            }
        }
        .background(.bw10)
        .environment(authVM)
    }
    private func signIn(email: String, password: String) {
        Task {
            authVM.errorMessage = nil
            authState = await authVM.signIn(email: email, password: password)
        }
    }
    private func signUp(email: String, password: String) {
        Task {
            authVM.errorMessage = nil
            let state = await authVM.signUp(email: email, password: password)
            if state == .authenticated {
                flow = .preferences
            }
        }
    }
    private func updateProfile(avatar: UIImage? = nil, username: String = "", lang: String? = "en", country: String? = "US") {
        Task {
            authState = await authVM.updateProfile(avatar: avatar, username: username, lang: lang, country: country)
        }
    }
}

#Preview {
    AuthenticationScreen(authState: .constant(.unauthenticated))
        .environment(Auth())
}
