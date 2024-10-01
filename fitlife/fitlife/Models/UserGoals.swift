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
    typealias LocaleIdentifier = String
    private(set) var localeIdentifier: LocaleIdentifier
    var locale: Locale {
        get { Locale(identifier: localeIdentifier) }
        set { localeIdentifier = newValue.identifier }
    }
    var name: String
    var height: Double
    var age: Int
    var gender: String
    var startingWeight: Double
    var currentWeight: Double
    var goalWeight: Double
    var activityLevel: ActivityLevel
    var weeklyGoal: WeeklyGoal
    var baseGoals: [BaseGoal]
    var nutritionGoals: [NutritionGoal]
    
    init(localeIdentifier: LocaleIdentifier = Locale.autoupdatingCurrent.identifier, height: Double = 0, age: Int = 0, gender: String = "", name: String = "", startingWeight: Double = 0, currentWeight: Double = 0, goalWeight: Double = 0, weeklyGoal: WeeklyGoal = .maintainWeight, activityLevel: ActivityLevel = .sedentary, baseGoals: [BaseGoal] = [], nutritionGoals: [NutritionGoal] = []) {
        self.localeIdentifier = localeIdentifier
        self.name = name
        self.height = height
        self.age = age
        self.gender = gender
        self.startingWeight = startingWeight
        self.currentWeight = currentWeight
        self.goalWeight = goalWeight
        self.weeklyGoal = weeklyGoal
        self.activityLevel = activityLevel
        self.baseGoals = baseGoals
        self.nutritionGoals = nutritionGoals
        }
}

extension UserGoals {
    static var mockUserGoals = UserGoals(
            height: 175,  // example height in cm
            age: 25,
            gender: "Male",
            name: "John Doe",
            startingWeight: 75,  // example weight in kg
            currentWeight: 75,
            goalWeight: 70,
            weeklyGoal: .maintainWeight,
            activityLevel: .sedentary,
            baseGoals: [.weightLoss, .muscleGain],
            nutritionGoals: [.eatVegan]
        )
}
