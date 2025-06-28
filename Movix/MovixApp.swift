//
//  MovixApp.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI
import Supabase

@main
struct MovixApp: App {
    
    @State var auth: Auth = .init()
//    @State var authState: AuthState = .unauthenticated
    
    let storageClient: SupabaseStorageClient = .development
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showOnboarding {
                    OnBoardingScreen()
                } else {
                    AuthenticatedScreen()
                        .statusBarHidden()
                        .environment(auth)
                }
            }
            .preferredColorScheme(.dark)
        }
        .environment(\.storageClient, storageClient)
    }
}
