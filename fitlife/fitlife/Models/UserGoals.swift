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
    
    @Relationship(deleteRule: .cascade, inverse: \BodyMetrics.userGoals) var bodyMetrics: BodyMetrics
    @Relationship(deleteRule: .cascade, inverse: \UserProfile.userGoals) var userProfile: UserProfile

    var currentDailyIntake: [DailyIntake] // Track daily macros
    var weeklySummaries: [WeeklySummary] // Track progress on a week-by-week basis

    var profilePicture: Data?
    
    // Initialize the UserGoals object with default values
    init(localeIdentifier: LocaleIdentifier = Locale.autoupdatingCurrent.identifier,
         weeklyGoal: WeeklyGoal = .maintainWeight,
         activityLevel: ActivityLevel = .sedentary,
         baseGoals: [BaseGoal] = [],
         nutritionGoals: [NutritionGoal] = [],
         workoutGoal: Int = 0,
         proteinGoal: Double = 0,
         fatsGoal: Double = 0,
         carbsGoal: Double = 0,
         caloriesGoal: Double = 0,
         isMetric: Bool = true,
         userProfile: UserProfile = UserProfile(name: "",
                                                age: 0,
                                                heightInCm: 160,
                                                gender: "male",
                                                isMetric: true),
         bodyMetrics: BodyMetrics = BodyMetrics(),
         currentDailyIntake: [DailyIntake] = [],
         weeklySummaries: [WeeklySummary] = []) {
        
        self.localeIdentifier = localeIdentifier
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
        
        self.userProfile = userProfile
        self.bodyMetrics = bodyMetrics
        self.currentDailyIntake = currentDailyIntake
        self.weeklySummaries = weeklySummaries
    }
    
    func calculateTDEE(isMetric: Bool = false) -> Double {
        let bmr = bodyMetrics.calculateBMR()
        let tdee = bmr * activityLevel.calorieMultiplier()
        
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

//extension UserGoals {
//    static var mockUserGoals = UserGoals(
//        weeklyGoal: .maintainWeight,
//        activityLevel: .sedentary,
//        baseGoals: [.weightLoss, .muscleGain],
//        nutritionGoals: [.eatVegan],
//        workoutGoal: 0,
//        userProfile: UserProfile?,
//        bodyMetrics: BodyMetrics?,
//        currentDailyIntake: [DailyIntake],
//        weeklySummaries: [WeeklySummary])
//}
