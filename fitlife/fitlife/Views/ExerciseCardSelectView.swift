//
//  ExerciseCardSelectView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/14/24.
//

import SwiftUI

struct ExerciseCardSelectView: View {
    var exercise: Exercise
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            // Exercise Image
            if !exercise.imageName.isEmpty {
                AsyncImage(url: URL(string: exercise.imageName)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    case .failure(_):
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(15)
                .overlay(
                    // Selection Checkmark
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .green : .gray)
                        .padding(8),
                    alignment: .topTrailing
                )
            }

            VStack(alignment: .leading, spacing: 8) {
                // Exercise Name and Difficulty
                HStack {
                    Text(exercise.name)
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .foregroundColor(.primary)
                    Spacer()
                    DifficultyBadge(difficulty: exercise.difficulty)
                }

                // Primary Muscles Worked
                if !exercise.primaryMuscles.isEmpty {
                    Text(exercise.primaryMuscles.joined(separator: ", "))
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.secondary)
                }

                // Equipment and Type
                HStack(spacing: 16) {
                    if let equipment = exercise.equipment {
                        Label(equipment.capitalized, systemImage: "dumbbell.fill")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.secondary)
                    }

                    Text(exercise.type.capitalized)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture {
            action()
        }
    }
}
