//  ExerciseDetailView.swift
//  Created by Luke Flannigan on 10/17/24.

import SwiftUI

struct ExerciseDetailView: View {
    var exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // Image at the top
                if let uiImage = UIImage(named: exercise.imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .overlay(
                            Text("Image Not Available")
                                .foregroundColor(.gray)
                                .font(.custom("Poppins-SemiBold", size: 18))
                        )
                }

                // Content below the image
                VStack(alignment: .leading, spacing: 16) {
                    // Exercise name
                    Text(exercise.name)
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(.primary)
                        .padding(.top)
                    
                    // Exercise description
                    Text(exercise.exerciseDescription)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

