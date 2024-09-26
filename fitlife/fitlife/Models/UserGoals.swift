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
    var baseGoals: [BaseGoal]
    
    init(name: String = "", startingWeight: Double = 0, currentWeight: Double = 0, goalWeight: Double = 0, weeklyGoal: WeeklyGoal = .maintainWeight, activityLevel: ActivityLevel = .sedentary, baseGoals: [BaseGoal] = []) {
            self.name = name
            self.startingWeight = startingWeight
            self.currentWeight = currentWeight
            self.goalWeight = goalWeight
            self.weeklyGoal = weeklyGoal
            self.activityLevel = activityLevel
            self.baseGoals = baseGoals
        }
}
