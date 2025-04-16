//
//  MovixApp.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI


@main
struct MovixApp: App {
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedScreen()
                .preferredColorScheme(.dark)
                .statusBarHidden()
                
        }
    }
}
