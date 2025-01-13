//
//  DailyIntake.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 10/21/24.
//

import Foundation
import SwiftData

@Model
class WeeklySummary: Identifiable {
    var id: UUID
    var weekStartDate: Date
    var weekEndDate: Date
    var totalCaloriesConsumed: Double
    var totalCaloriesBurned: Double
    var totalProtein: Double
    var totalCarbs: Double
    var totalFats: Double
    var workoutSessionsCompleted: Int
    var workoutGoal: Int
    
    init(id: UUID = UUID(), weekStartDate: Date, weekEndDate: Date, totalCaloriesConsumed: Double, totalCaloriesBurned: Double, totalProtein: Double, totalCarbs: Double, totalFats: Double, workoutSessionsCompleted: Int, workoutGoal: Int) {
        self.id = id
        self.weekStartDate = weekStartDate
        self.weekEndDate = weekEndDate
        self.totalCaloriesConsumed = totalCaloriesConsumed
        self.totalCaloriesBurned = totalCaloriesBurned
        self.totalProtein = totalProtein
        self.totalCarbs = totalCarbs
        self.totalFats = totalFats
        self.workoutSessionsCompleted = workoutSessionsCompleted
        self.workoutGoal = workoutGoal
    }
    
}
