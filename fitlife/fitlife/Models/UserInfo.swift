//
//  UserInfo.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/25/24.
//

import Foundation
import SwiftData

@Model
class UserGoals {
    var name: String
    var startingWeight: Double
    var currentWeight: Double
    var goalWeight: Double
    var activityLevel: ActivityLevel
    var weeklyGoal: WeeklyGoal
    
    init(name: String, startingWeight: Double, currentWeight: Double, goalWeight: Double, weeklyGoal: WeeklyGoal, activityLevel: ActivityLevel) {
            self.name = name
            self.startingWeight = startingWeight
            self.currentWeight = currentWeight
            self.goalWeight = goalWeight
            self.weeklyGoal = weeklyGoal
            self.activityLevel = activityLevel
        }
}
