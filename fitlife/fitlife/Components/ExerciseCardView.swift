//  ExerciseCardView.swift
//  Created by Luke Flannigan on 10/17/24.

import SwiftUI

struct ExerciseCardView: View {
    var exercise: Exercise

    var body: some View {
        VStack(alignment: .leading) {
            if !exercise.imageName.isEmpty {
                Image(exercise.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(15)
            }

            Text(exercise.name)
                .font(.custom("Poppins-SemiBold", size: 18))
                .foregroundColor(.primary)
                .padding(.top, 5)

            Text(exercise.exerciseDescription)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.secondary)
                .lineLimit(2)
                .padding(.bottom, 5)
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}


