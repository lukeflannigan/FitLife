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
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(exercise.name)
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .foregroundColor(.primary)
                    Spacer()
                    DifficultyBadge(difficulty: exercise.difficulty)
                }

                if !exercise.primaryMuscles.isEmpty {
                    Text(exercise.primaryMuscles.joined(separator: ", "))
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.secondary)
                }

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
    }
}

struct DifficultyBadge: View {
    let difficulty: Difficulty

    var color: Color {
        switch difficulty {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }

    var body: some View {
        Text(difficulty.rawValue)
            .font(.custom("Poppins-Medium", size: 12))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}


