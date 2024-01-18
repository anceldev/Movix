//
//  MovixApp.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Authenticaiton emulator settings
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
        // Firestore emulator settings
        let settings = Firestore.firestore().settings
        settings.host = "127.0.0.1:8080"
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        return true
    }
}


@main
struct MovixApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AuthenticatedView(unauthenticated: {
                    StartView()
                }, content: {
                    MainTabView()
                    Spacer()
                })
                .foregroundStyle(.blackWhite)
                //.background(.blackApp)
            }
        }
        .environmentObject(AuthenticationViewModel())
    }
}
