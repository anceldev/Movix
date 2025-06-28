//
//  AuthenticatedScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI
@_exported import Inject

struct AuthenticatedScreen: View {
    
    @Environment(Auth.self) var auth
    @State private var authState: AuthState = .unauthenticated
    
    @ObserveInjection var forceRedraw
    
    var body: some View {
        VStack {
            switch authState {
            case .authenticated:
//                Text("Main Tab view")
                MainTabView(user: auth.user!)
            case .authenticating:
                ProgressView()
                    .tint(.marsB)
                    .progressViewStyle(.circular)
            case .unauthenticated:
                AuthenticationScreen(authState: $authState)
                    .environment(auth)
            }
        }
        .enableInjection()
//        .onAppear {
//            authState = authVM.user != nil ? .authenticated : .unauthenticated
//        }
        .onChange(of: auth.state) { _, newValue in
            authState = newValue == .authenticated ? .authenticated : .unauthenticated
        }
    }
}

#Preview {
    AuthenticatedScreen()
        .environment(NavigationManager())
}
