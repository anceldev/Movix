//
//  MovixApp.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Auth.auth().useEmulator(withHost: "localhost", port: 9099) // Emulator used for testing.
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
                    Image(systemName: "film")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Welcome to Movix")
                        .font(.title)
                    Text("You need to be logged in to use this app.")
                }, content: {
                    MainView()
                    Spacer()
                })
            }
        }
    }
}
