//
//  WorkoutLibraryView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/28/24.
//

import SwiftUI

struct WorkoutLibraryView: View {
    @State private var workouts: [Workout] = Workout.mockWorkoutEntries // TODO: REMOVE THIS, NEEDS TO PULL FROM USER DATA WORKOUTS

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(workouts) { workout in
                        NavigationLink(destination: WorkoutsView(workout: workout)) {
                            WorkoutCard(workout: workout)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Workout Library")
        }
    }
}

// MARK: - Workout Card
struct WorkoutCard: View {
    var workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(workout.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Spacer()
                
                if workout.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }

            .font(.subheadline)
            .foregroundColor(.secondary)

            .font(.footnote)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    WorkoutLibraryView()
}
