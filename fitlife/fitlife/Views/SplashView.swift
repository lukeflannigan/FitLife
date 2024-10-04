//
//  SplashView.swift
//  fitlife
//
//  Created by Jonas Tuttle on 10/4/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false  // Flag to track when to navigate
    
    var body: some View {
        ZStack {
            GradientBackground()  // Use your custom gradient background
            
            if isActive {
                OpeningView()  // Navigate to OpeningView
            } else {
                VStack {
                    // Display "FitLife" as the main splash screen text
                    Text("FitLife")
                        .font(.system(size: 48, weight: .bold))  // Large, bold text
                        .foregroundColor(.white)  // Ensure text is visible on gradient
                        .padding()
                }
            }
        }
        .onAppear {
            // Simulate a brief delay for the splash screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
