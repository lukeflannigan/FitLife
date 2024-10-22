//
//  SplashView.swift
//  fitlife
//
//  Created by Jonas Tuttle on 10/4/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false  // Flag to track when to navigate
    @State private var destination: AnyView? = nil  // Dynamic destination
    
    var body: some View {
        ZStack {
            GradientBackground()  // Custom gradient background
            
            if isActive, let destination = destination {
                destination
            } else {
                VStack {
                    Text("FitLife")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                checkUserStatus()
            }
        }
    }
    
    // Check user status: Signed in, skipped, or first time
    private func checkUserStatus() {
        if let _ = UserDefaults.standard.string(forKey: "userSession") {
            // User has signed in before
            self.destination = AnyView(MainView())
        } else if UserDefaults.standard.bool(forKey: "skippedSignIn") {
            // User has skipped sign-in before
            self.destination = AnyView(MainView())
        } else {
            // First time user, show OpeningView
            self.destination = AnyView(OpeningView())
        }
        
        withAnimation {
            self.isActive = true
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
