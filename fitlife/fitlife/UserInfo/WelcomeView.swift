//
//  WelcomeView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/25/24.
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    @Environment(\.modelContext) var modelContext
    @State var userGoals: UserGoals
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("What's your name?")
                    .font(.title2)
                    .bold()
                HStack {
                    TextField("Name", text: $userGoals.name)
                        .padding()
                        .background(Color(.systemGray6))  // Optional background for clarity
                        .cornerRadius(10)
                }
                .padding()
                .frame(maxWidth: .infinity)
                Spacer()
                Button(action: {
//                    modelContext.save()
                }) {
                    Text("Continue")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)  // Full width
                        .padding()  // Add padding to make it more tappable
                        .foregroundColor(Color.white)  // White text
                        .background(Color.black)  // Black background
                        .cornerRadius(10)  // Rounded corners
                }
                .frame(height: 50)  // Ensure the button has a consistent height
                .padding(.horizontal)  // Add padding around the button for spacing
            }
            .padding()

            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                Button(action: {}) {
//                    Image(systemName: "arrow.2.circlepath.circle")
//                }
//            }
        }
    }
}

#Preview {
    WelcomeView(userGoals: UserGoals())
}
