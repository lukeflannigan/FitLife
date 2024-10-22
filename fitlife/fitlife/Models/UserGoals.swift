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
    var heightInCm: Double
    var age: Int
    var gender: String
    var startingWeightInKg: Double
    var currentWeightInKg: Double
    var goalWeightInKg: Double
    var activityLevel: ActivityLevel
    var weeklyGoal: WeeklyGoal
    var baseGoals: [BaseGoal]
    var nutritionGoals: [NutritionGoal]
    var workoutGoal: Int
    var proteinGoal: Double
    var fatsGoal: Double
    var carbsGoal: Double
    var caloriesGoal: Double
    var isMetric: Bool // Tracks if the user prefers metric or imperial
    
    // Add properties to store current progress
    var currentDailyIntake: [DailyIntake] // Track daily macros
    var weeklySummaries: [WeeklySummary] // Track progress on a week-by-week basis
    var bodyWeightLog: [BodyWeightEntry]
    
    // Initialize the UserGoals object with default values
    init(localeIdentifier: LocaleIdentifier = Locale.autoupdatingCurrent.identifier,
         heightInCm: Double = 0,
         age: Int = 0,
         gender: String = "",
         name: String = "",
         startingWeightInKg: Double = 0,
         currentWeightInKg: Double = 0,
         goalWeightInKg: Double = 0,
         weeklyGoal: WeeklyGoal = .maintainWeight,
         activityLevel: ActivityLevel = .sedentary,
         baseGoals: [BaseGoal] = [],
         nutritionGoals: [NutritionGoal] = [],
         workoutGoal: Int = 0,
         proteinGoal: Double = 0,
         fatsGoal: Double = 0,
         carbsGoal: Double = 0,
         caloriesGoal: Double = 0,
         isMetric: Bool = true) {
        
        self.localeIdentifier = localeIdentifier
        self.name = name
        self.heightInCm = heightInCm
        self.age = age
        self.gender = gender
        self.startingWeightInKg = startingWeightInKg
        self.currentWeightInKg = currentWeightInKg
        self.goalWeightInKg = goalWeightInKg
        self.weeklyGoal = weeklyGoal
        self.activityLevel = activityLevel
        self.baseGoals = baseGoals
        self.nutritionGoals = nutritionGoals
        self.workoutGoal = workoutGoal
        self.proteinGoal = proteinGoal
        self.fatsGoal = fatsGoal
        self.carbsGoal = carbsGoal
        self.caloriesGoal = caloriesGoal
        self.isMetric = isMetric // Defaults to metric unless specified
    }
    
    func calculateTDEE(isMetric: Bool = false) -> Double {
        let weightInKg = currentWeightInKg
        let heightInCm = self.heightInCm
        
        // Calculate BMR based on gender
        let bmr: Double
        if gender.lowercased() == "male" {
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) + 5
        } else {
            bmr = 10 * weightInKg + 6.25 * heightInCm - 5 * Double(age) - 161
        }
        
        let tdee = bmr * activityMultiplier
        
        // Adjust for weekly goal
        switch weeklyGoal {
        case .loseWeightSlow: return tdee - 250
        case .loseWeightMedium: return tdee - 500
        case .loseWeightFast: return tdee - 1000
        case .gainWeightSlow: return tdee + 250
        case .gainWeightMedium: return tdee + 500
        case .gainWeightFast: return tdee + 1000
        default: return tdee
        }
    }
    
    func setMacroGoals() {
        // Get the adjusted TDEE
        let tdee = calculateTDEE()

        // Set default macro percentages
        var proteinPercentage = 0.3  // Default: 30% of total calories
        var fatsPercentage = 0.25    // Default: 25% of total calories
        var carbsPercentage = 0.45   // Default: 45% of total calories
        
        // Adjust based on user's primary BaseGoal
        if baseGoals.contains(.weightLoss) {
            proteinPercentage = 0.35  // Increase protein to retain muscle mass during weight loss
            fatsPercentage = 0.2      // Lower fat to reduce calories
            carbsPercentage = 0.45    // Adjust carbs to balance energy
        } else if baseGoals.contains(.muscleGain) {
            proteinPercentage = 0.40  // Increase protein for muscle gain
            fatsPercentage = 0.25     // Moderate fat intake
            carbsPercentage = 0.35    // Keep carbs lower but sufficient for energy
        } else if baseGoals.contains(.weightMaintain) {
            // Keep the default balance for weight maintenance
        }
        
        // Adjust further based on user's nutrition goals
        for goal in nutritionGoals {
            switch goal {
            case .moreProtein:
                proteinPercentage = min(proteinPercentage + 0.05, 0.45)  // Increase protein (max 45%)
                carbsPercentage -= 0.05  // Adjust carbs to balance total
            case .lessProtein:
                proteinPercentage = max(proteinPercentage - 0.05, 0.2)   // Decrease protein (min 20%)
                carbsPercentage += 0.05
            case .moreFats:
                fatsPercentage = min(fatsPercentage + 0.05, 0.35)        // Increase fats (max 35%)
                carbsPercentage -= 0.05
            case .lessFats:
                fatsPercentage = max(fatsPercentage - 0.05, 0.2)         // Decrease fats (min 20%)
                carbsPercentage += 0.05
            case .eatVegan, .eatVegetarian:
                proteinPercentage = max(proteinPercentage - 0.05, 0.2)   // Reduce protein for plant-based diet
                carbsPercentage = 0.55  // Increase carbs for plant-based intake
                fatsPercentage = 0.20
            case .moreVeggies, .moreFruits:
                carbsPercentage = min(carbsPercentage + 0.05, 0.6)       // Increase carbs for veggie/fruit focus
                fatsPercentage = max(fatsPercentage - 0.05, 0.2)
            default:
                break
            }
        }

        // Calculate macros in calories
        let proteinCalories = tdee * proteinPercentage
        let fatsCalories = tdee * fatsPercentage
        let carbsCalories = tdee * carbsPercentage

        // Convert calories to grams (protein & carbs = 4 cal/g, fats = 9 cal/g)
        self.proteinGoal = proteinCalories / 4
        self.fatsGoal = fatsCalories / 9
        self.carbsGoal = carbsCalories / 4
        self.caloriesGoal = tdee
    }
}

extension UserGoals {
    static var mockUserGoals = UserGoals(
        heightInCm: 175,  // example height in cm
        age: 25,
        gender: "Male",
        name: "John Doe",
        startingWeightInKg: 75,  // example weight in kg
        currentWeightInKg: 75,
        goalWeightInKg: 70,
        weeklyGoal: .maintainWeight,
        activityLevel: .sedentary,
        baseGoals: [.weightLoss, .muscleGain],
        nutritionGoals: [.eatVegan],
        workoutGoal: 0
    )
}
