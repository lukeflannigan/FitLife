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
    @State private var name: String = ""   //As in, what is the name of the food item you ate?
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fats: String = ""
    
    
    
    var body: some View {
        ZStack {
            // Gradient background for the entire screen
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea() // Covers the entire screen with gradient
            VStack {
                Text("Log Your Food Intake")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                
                Form {
                    Section(header: Text("Food Details")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                        .foregroundColor(.white))
                    {
                        
                        TextField("What did you eat?", text: $name) .padding()
                            .background(Color.white.opacity(0.8)) // Light background for contrast
                            .cornerRadius(10)
                        TextField("Calories", text: $calories) .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .keyboardType(.decimalPad)
                        TextField("Protein (g)", text: $protein)
                            .keyboardType(.decimalPad).keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        TextField("Carbohydrates (g)", text: $carbs)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        TextField("Fats (g)", text: $fats)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear) // Make each row background transparent
                    
                    Section {
                        Button(action: {
                            addFoodEntry()
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Entry")
                                    .fontWeight(.semibold)
                                    .padding(.leading, 5)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.clear) // Remove extra styling
                    }
                }
                .scrollContentBackground(.hidden) // Removes form background
            }
            .padding()
        }
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
        } catch {
            print("Failed to save food entry: \(error.localizedDescription)")
        }
    }
}
    
    struct LogHomeView: View {
        var body: some View {
            NavigationView {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        // Navigation Cards
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
                    .padding()
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
    
