//  NutritionView.swift
//  Created by Luke Flannigan on 10/1/24.

import SwiftUI

struct NutritionView: View {
    @State private var foods: [Food] = [
        Food(name: "Chicken", calories: 200, protein: 30, carbs: 0, fat: 5),
        Food(name: "Rice", calories: 250, protein: 5, carbs: 45, fat: 0),
        Food(name: "Broccoli", calories: 50, protein: 1, carbs: 15, fat: 0),
        Food(name: "Salmon", calories: 200, protein: 30, carbs: 0, fat: 10),
    ]
    
    private var totalCalories: Int {
        foods.reduce(0) { $0 + $1.calories }
    }
    
    private var totalProtein: Double {
        foods.reduce(0) { $0 + $1.protein }
    }
    
    private var totalCarbs: Double {
        foods.reduce(0) { $0 + $1.carbs }
    }
    
    private var totalFat: Double {
        foods.reduce(0) { $0 + $1.fat }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                caloricIntakeSection
                macronutrientsSection
                foodsLoggedSection
                actionButtonsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 80) // To account for tab bar.
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Nutrition")
                    .font(.custom("Poppins-Bold", size: 28))
                    .foregroundColor(.primary)
                Text("Track your daily intake")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }

    private var caloricIntakeSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Today's Calories")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }

            CaloricIntakeCard(currentCalories: totalCalories, goalCalories: 2000)
        }
    }

    private var macronutrientsSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Macronutrients")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }

            VStack(spacing: 15) {
                MacroNutrientProgressCard(
                    nutrientName: "Protein",
                    currentAmount: Int(totalProtein),
                    goalAmount: 120,
                    color: Color("GradientStart")
                )
                MacroNutrientProgressCard(
                    nutrientName: "Carbs",
                    currentAmount: Int(totalCarbs),
                    goalAmount: 250,
                    color: Color("GradientEnd")
                )
                MacroNutrientProgressCard(
                    nutrientName: "Fats",
                    currentAmount: Int(totalFat),
                    goalAmount: 65,
                    color: Color("GradientStart")
                )
            }
        }
    }

    private var foodsLoggedSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Foods Logged")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.primary)
                Spacer()
            }

            ForEach(foods) { food in
                NavigationLink(destination: FoodDetailView(food: food)) {
                    ActivityRow(icon: "fork.knife", title: food.name, subtitle: "\(food.calories) cal", time: "")
                }
            }
        }
    }

    private var actionButtonsSection: some View {
        HStack(spacing: 20) {
            ActionButton(title: "Add Food", iconName: "plus.circle.fill") {
                // Add food
            }
            ActionButton(title: "Scan Barcode", iconName: "barcode.viewfinder") {
                // Barcode scanning implemented eventually
            }
        }
        .padding(.top, 10)
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
    }
}
