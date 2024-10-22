// OpeningView.swift
//
// Created by Luke Flannigan on 9/26/24.
//
import SwiftUI
import SwiftData

struct OpeningView: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 2) {
                    Spacer()
                    
                    // "FitLife" Title
                    Text("FitLife")
                        .font(.custom("Poppins-Bold", size: 48))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // "TRAINING DONE SMARTER" Subtitle
                    Text("TRAINING DONE SMARTER")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(Color("TextGray"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                    
                    Spacer()
                    
                    // "Get Started" Button
                    NavigationLink(destination: SignUpView()) {
                        Text("Get Started")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(.black)
                            .frame(width: 300, height: 48)
                            .background(Color.white)
                            .cornerRadius(22)
                    }
                    .padding(.bottom, 20)
                    
                    // "Log In" Text as NavigationLink
                    NavigationLink(destination: SignInView()) {
                        Text("Log In")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 70)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct OpeningView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningView()
    }
}

