//
//  BodyMetrics.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 10/22/24.
//

import Foundation
import SwiftData

@Model
class BodyMetrics {
    var id: UUID
    var startingWeightInKg: Double
    var currentWeightInKg: Double
    var goalWeightInKg: Double
    var bodyWeightLog: [BodyWeightEntry]
    var userGoals: UserGoals?

    init(id: UUID = UUID(), startingWeightInKg: Double = 0, currentWeightInKg: Double = 0, goalWeightInKg: Double = 0, bodyWeightLog: [BodyWeightEntry] = []) {
        self.id = id
        self.startingWeightInKg = startingWeightInKg
        self.currentWeightInKg = currentWeightInKg
        self.goalWeightInKg = goalWeightInKg
        self.bodyWeightLog = bodyWeightLog
    }
    
    func calculateBMR() -> Double {
        let height = userGoals?.userProfile.heightInCm ?? 0
        let gender = userGoals?.userProfile.gender.lowercased()
        let age = userGoals?.userProfile.age
        let weightInKg = bodyWeightLog.last?.weight ?? currentWeightInKg // Use latest logged weight or currentWeightInKg
        var bmr: Double = 0
        
        if gender == "male" {
            let baseBMR = 10 * weightInKg + 6.25 * height - 5 * Double(age ?? 0)
            bmr = baseBMR + 5
        } else {
            let baseBMR = 10 * weightInKg + 6.25 * height - 5 * Double(age ?? 0)
            bmr = baseBMR - 161
        }
        
        return bmr
    }
    
    

    // Method to log daily weight
    func logWeight(_ weightInKg: Double, modelContext: ModelContext) {
        currentWeightInKg = weightInKg
        bodyWeightLog.append(BodyWeightEntry(date: Date(), weight: currentWeightInKg))
        try? modelContext.save()
        adjustGoalsBasedOnWeight()
    }

    // Adjust related goals when weight changes
    func adjustGoalsBasedOnWeight() {
        // Placeholder: Adjust other goals based on weight change
    }
    
    // Convert current weight to pounds if needed
    func currentWeightInPounds() -> Double {
        return currentWeightInKg * 2.20462
    }

    // Set current weight from pounds if using imperial units
    func setCurrentWeightFromPounds(pounds: Double) {
        currentWeightInKg = pounds * 0.453592
    }

    // Convert goal weight to pounds if needed
    func goalWeightInPounds() -> Double {
        return goalWeightInKg * 2.20462
    }

    // Set goal weight from pounds if using imperial units
    func setGoalWeightFromPounds(pounds: Double) {
        goalWeightInKg = pounds * 0.453592
    }
}
