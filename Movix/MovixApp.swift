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
import FirebaseStorage


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        /// Firebase Emulator settings
        /// Authentication
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        /// Firestore
        let settings = Firestore.firestore().settings
        settings.host = "127.0.0.1:8080"
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        /// Storage
        Storage.storage().useEmulator(withHost: "127.0.0.1", port: 9199)
        
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
                AuthenticatedView()
            }
        }
        .environmentObject(AuthenticationViewModel())
    }
}
