//
//  fitlifeApp.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/24/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("Firebase is configured")
    return true
  }
}

@main
struct YourApp: App {
    let modelContainer: ModelContainer
  // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
            do {
                modelContainer = try ModelContainer(for: UserGoals.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .modelContainer(modelContainer)
      }
    }
  }
}
