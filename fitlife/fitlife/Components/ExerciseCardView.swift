//  ExerciseCardView.swift
//  Created by Luke Flannigan on 10/17/24.

import SwiftUI

struct ExerciseCardView: View {
    var exercise: Exercise

    var body: some View {
        VStack(alignment: .leading) {
            if !exercise.imageName.isEmpty {
                AsyncImage(url: URL(string: exercise.imageName)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    case .failure(_):
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(15)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(exercise.name)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)

                if !exercise.primaryMuscles.isEmpty {
                    Text(exercise.primaryMuscles.joined(separator: ", "))
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.secondary)
                }

                if let equipment = exercise.equipment {
                    Text("Equipment: \(equipment)")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}


