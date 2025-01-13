//
//  DailyProgress.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 10/22/24.
//

import Foundation
import SwiftData

@Model
class DailyProgress {
    var currentDailyIntake: [DailyIntake]
    var caloriesGoal: Double
    var proteinGoal: Double
    var fatsGoal: Double
    var carbsGoal: Double

    init(currentDailyIntake: [DailyIntake] = [], caloriesGoal: Double = 0, proteinGoal: Double = 0, fatsGoal: Double = 0, carbsGoal: Double = 0) {
        self.currentDailyIntake = currentDailyIntake
        self.caloriesGoal = caloriesGoal
        self.proteinGoal = proteinGoal
        self.fatsGoal = fatsGoal
        self.carbsGoal = carbsGoal
    }

    // Log daily intake
    func logIntake(_ intake: DailyIntake) {
        currentDailyIntake.append(intake)
        // Adjust daily stats or goals if needed
    }

    // Computed property for total calories consumed
    var caloriesConsumed: Double {
        return currentDailyIntake.reduce(0) { $0 + $1.calories }
    }

    // Computed property for calorie progress percentage
    var calorieProgressPercentage: Int {
        guard caloriesGoal > 0 else { return 0 }
        return Int((caloriesConsumed / caloriesGoal) * 100)
    }

    // Save method for persistence or updates
    func save() {
        // Placeholder for save logic (e.g., database or file storage)
        print("Daily progress saved: \(caloriesConsumed) calories consumed out of \(caloriesGoal)")
    }
}
