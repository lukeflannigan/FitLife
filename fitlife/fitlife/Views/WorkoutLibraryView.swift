//
//  WorkoutLibraryView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/28/24.
//

import SwiftUI

struct WorkoutLibraryView: View {
    @State private var workouts: [Workout] = Workout.mockWorkoutEntries

    var body: some View {
        NavigationView{
            Form {
                List(workouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .font(.headline)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Workout Library")
    }
}

#Preview {
    WorkoutLibraryView()
}
