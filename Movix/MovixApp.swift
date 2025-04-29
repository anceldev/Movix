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
    
    let storageClient: SupabaseStorageClient = .development
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedScreen()
                .preferredColorScheme(.dark)
                .statusBarHidden()
        }
        .environment(\.storageClient, storageClient)
    }
}
