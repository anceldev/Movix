//
//  MovixApp.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI


@main
struct MovixApp: App {
//    init() {
//        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")!.load()
//    }
    var body: some Scene {
        WindowGroup {
            AuthenticatedScreen()
                .colorScheme(.dark)
                .statusBarHidden()
        }
    }
}
