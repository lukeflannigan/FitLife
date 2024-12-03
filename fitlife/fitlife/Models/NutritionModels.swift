import Foundation
import SwiftData

enum MealType: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}

@Model
class FoodItem {
    var id: UUID
    var name: String
    var brandName: String?
    var servingSize: String
    var servingSizeGrams: Double
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var fatSecretId: String?
    
    init(id: UUID = UUID(), 
         name: String, 
         brandName: String? = nil,
         servingSize: String,
         servingSizeGrams: Double,
         calories: Int, 
         protein: Double, 
         carbs: Double, 
         fat: Double,
         fatSecretId: String? = nil) {
        self.id = id
        self.name = name
        self.brandName = brandName
        self.servingSize = servingSize
        self.servingSizeGrams = servingSizeGrams
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.fatSecretId = fatSecretId
    }
}

@Model
class NutritionEntry {
    var id: UUID
    var foodItem: FoodItem
    var servings: Double
    var date: Date
    var mealType: MealType
    
    init(id: UUID = UUID(), 
         foodItem: FoodItem, 
         servings: Double, 
         date: Date,
         mealType: MealType) {
        self.id = id
        self.foodItem = foodItem
        self.servings = servings
        self.date = Calendar.current.startOfDay(for: date)
        self.mealType = mealType
    }
    
    var totalCalories: Int {
        Int(Double(foodItem.calories) * servings)
    }
    
    var totalProtein: Double {
        foodItem.protein * servings
    }
    
    var totalCarbs: Double {
        foodItem.carbs * servings
    }
    
    var totalFat: Double {
        foodItem.fat * servings
    }
}

@Model
class DailyNutritionLog {
    @Attribute(.unique) var date: Date
    @Relationship(deleteRule: .cascade) var entries: [NutritionEntry]
    
    init(date: Date = Date(), entries: [NutritionEntry] = []) {
        self.date = Calendar.current.startOfDay(for: date)
        self.entries = entries
    }
    
    var totalCalories: Int {
        entries.reduce(0) { $0 + $1.totalCalories }
    }
    
    var totalProtein: Double {
        entries.reduce(0) { $0 + $1.totalProtein }
    }
    
    var totalCarbs: Double {
        entries.reduce(0) { $0 + $1.totalCarbs }
    }
    
    var totalFat: Double {
        entries.reduce(0) { $0 + $1.totalFat }
    }
    
    var entriesByMeal: [MealType: [NutritionEntry]] {
        Dictionary(grouping: entries) { $0.mealType }
    }
}
