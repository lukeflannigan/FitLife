//
//  WorkoutExercise.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/13/24.
//

import Foundation
import SwiftData

@Model
class WorkoutExercise: Identifiable {
    var id: UUID
    var exercise: Exercise?
    var workout: Workout?
    @Relationship(deleteRule: .cascade) var sets: [ExerciseSet] = []
    
    init(id: UUID = UUID(), exercise: Exercise, sets: [ExerciseSet] = []) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
    }
    func addSet(context: ModelContext) {
        let newSet = ExerciseSet(reps: 0, weight: 0)
        self.sets.append(newSet)
        context.insert(newSet)
        
    }
    func removeSet(at offsets: IndexSet, modelContext: ModelContext) {
        for offset in offsets {
            let objectID = self.sets[offset].persistentModelID
            let set = modelContext.model(for: objectID)
            modelContext.delete(set)
        }
        self.sets.remove(atOffsets: offsets)
        do {
            try modelContext.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    var sortedSets: [ExerciseSet] {
        return sets.sorted {$0.date < $1.date}
    }
    var bestSet: ExerciseSet {
        return sets.max {$1.weight > $0.weight} ?? ExerciseSet.emptySet
    }
}

