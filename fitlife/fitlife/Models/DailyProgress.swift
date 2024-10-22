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
}
