//
//  AddAndSaveFoodEntries.swift
//  fitlife
//
//  Created by Sam Arshad on 10/31/24.
//

import SwiftUI
import Foundation

struct AddFoodEntryView: View{
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""   //As in, what is the name of the food item you ate?
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fats: String = ""
    
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
                    
                    Text("Add Food")
                        .font(.title3.bold())
                    
                    Spacer()
                
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                }
                .padding()
                
                // Form Fields
                VStack(alignment: .leading, spacing: 24) {
                    FormField(
                        label: "Food Name",
                        placeholder: "Enter food name",
                        text: $name
                    )
                    
                    FormField(
                        label: "Calories",
                        placeholder: "0",
                        text: $calories,
                        unit: "kcal",
                        keyboardType: .decimalPad
                    )
                    
                    // Macros Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Macronutrients")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(.bottom, 8)
                        
                        FormField(
                            label: "Protein",
                            placeholder: "0",
                            text: $protein,
                            unit: "g",
                            keyboardType: .decimalPad,
                            color: .blue
                        )
                        
                        FormField(
                            label: "Carbohydrates",
                            placeholder: "0",
                            text: $carbs,
                            unit: "g",
                            keyboardType: .decimalPad,
                            color: .purple
                        )
                        
                        FormField(
                            label: "Fats",
                            placeholder: "0",
                            text: $fats,
                            unit: "g",
                            keyboardType: .decimalPad,
                            color: .orange
                        )
                    }
                }
                
                // Save Button
                Button(action: addFoodEntry) {
                    Text("Save Food")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .padding(.horizontal, 24)
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
    }
    private func addFoodEntry() {
        //              Convert input strings to Double
        guard let caloriesDouble = Double(calories),
              let proteinDouble = Double(protein),
              let carbsDouble = Double(carbs),
              let fatsDouble = Double(fats),
              !name.isEmpty else {
            print("Invalid input") // Optional: add user feedback for invalid inputs
            return
        }
        
        //      Create a new DailyIntake object
        let newEntry = DailyIntake(
            calories: caloriesDouble,
            protein: proteinDouble,
            carbs: carbsDouble,
            fats: fatsDouble,
            name: name
        )
        
        //      Add to model context
        modelContext.insert(newEntry)
        
        
        //      Save the context
        do {
            try modelContext.save()
            print("Food entry saved successfully!")
            dismiss()
        } catch {
            print("Failed to save food entry: \(error.localizedDescription)")
        }
    }
}

private struct FormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var unit: String? = nil
    var keyboardType: UIKeyboardType = .default
    var color: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
            
            // Input Field
            HStack {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .font(.system(size: 17))
                
                if let unit = unit {
                    Text(unit)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct LogHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 16) {
                        NavigationLink(destination: AddFoodEntryView()) {
                            NavigationCard(
                                title: "Log Food",
                                subtitle: "Record your meals and snacks",
                                systemImage: "plus.circle.fill"
                            )
                        }
                        
                        NavigationLink(destination: SearchView()) {
                            NavigationCard(
                                title: "Search Food",
                                subtitle: "Find recipes and nutrition info",
                                systemImage: "magnifyingglass.circle.fill"
                            )
                        }
                        
                        NavigationLink(destination: LoggedFoodView()) {
                            NavigationCard(
                                title: "Food History",
                                subtitle: "View your logged meals",
                                systemImage: "clock.fill"
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    Spacer()
                }
            }
            .navigationTitle("Nutrition")
        }
    }
}

private struct NavigationCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 24))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct LogFoodView: PreviewProvider {
    static var previews: some View {
        LogHomeView()
        AddFoodEntryView()
    }
}
