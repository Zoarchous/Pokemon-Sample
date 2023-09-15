//
//  PokemonSampleApp.swift
//  PokemonSample
//
//  Created by user on 14.09.23.
//

import SwiftUI

@main
struct PokemonSampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        print("👷🏾‍♂️ Is UI Test Running: \(UITestingHelper.isUITesting)")
        #endif
        return true
    }
}
