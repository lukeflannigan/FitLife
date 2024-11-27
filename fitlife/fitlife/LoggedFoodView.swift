//
//  LoggedFoodView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/19/24.
//

import SwiftUI
import SwiftData

struct LoggedFoodView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \DailyIntake.date, order: .reverse) var loggedFood: [DailyIntake]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                // Custom navigation bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Logged Foods")
                        .font(.title3.bold())
                    
                    Spacer()
                    
                    NavigationLink(destination: AddFoodEntryView()) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                LazyVStack(spacing: 12) {
                    ForEach(loggedFood) { food in
                        FoodCard(food: food)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .background(Color(.systemGray6))
        .navigationBarHidden(true)
    }
}

// Extracted card view for better organization
private struct FoodCard: View {
    let food: DailyIntake
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(food.name)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Divider()
            
            HStack(spacing: 16) {
                NutrientLabel(title: "Calories", value: "\(Int(food.calories))", unit: "kcal")
                Spacer()
                NutrientLabel(title: "Protein", value: String(format: "%.1f", food.protein), unit: "g")
                Spacer()
                NutrientLabel(title: "Carbs", value: String(format: "%.1f", food.carbs), unit: "g")
                Spacer()
                NutrientLabel(title: "Fats", value: String(format: "%.1f", food.fats), unit: "g")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// Reusable nutrient label component
private struct NutrientLabel: View {
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
            Text("\(value)\n\(unit)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }
}
