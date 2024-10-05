//
//  WorkoutListView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 10/1/24.
//

import SwiftUI
import SwiftData

struct WorkoutItem: View {
    var workout: Workout // passing in workout object
    var body: some View {
        VStack() {
            // TODO: implement functionality to display formatted workout object
        }
    }
}


struct NewWorkoutForm: View {
    var body: some View {
        Text("Hello, World!") // TODO: implement add workout functionality
    }
}


struct WorkoutListView: View {
    @State private var workouts: [Workout] = []
    @State private var showingNewWorkoutForm = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            List {
                ForEach(workouts) { workout in
                    WorkoutItem(workout: workout)
                }
                .onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewWorkoutForm = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewWorkoutForm) {
                NewWorkoutForm(workouts: $workouts)
            }
        }
    }
    
    private func deleteWorkouts(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
    }
    
}

#Preview {
    WorkoutListView()
}
