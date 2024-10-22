//
//  fitlifeApp.swift
//  fitlife
//
//  Created by Thomas Mendoza on 9/24/24.
//

import SwiftUI
import SwiftData

@main
struct YourApp: App {
    let modelContainer: ModelContainer

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
                SplashView()
                    .modelContainer(modelContainer)
            }
        }
    }
}
