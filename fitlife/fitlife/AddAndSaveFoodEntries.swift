//
//  AddAndSaveFoodEntries.swift
//  fitlife
//
//  Created by Sam Arshad on 10/31/24.
//

import SwiftUI
import Foundation

struct AddFoodEntryView: View{
    @State private var name: String = ""   //As in, what is the name of the food item you ate?
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fats: String = ""
    
    
    
    var body: some View {
        ZStack {
            // Gradient background for the entire screen
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
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

    
    func addFoodEntry() {
        guard var caloriesDouble = Double(calories),
              var proteinDouble = Double(protein),
              var carbsDouble = Double(carbs),
              var fatsDouble = Double(fats) else {
            print("Invalid input")
            return
        }
    }
    
    /* This is for when DataPersistence is added in.
     private func addFoodEntry() {
             // Convert input strings to Double
             guard let caloriesDouble = Double(calories),
                   let proteinDouble = Double(protein),
                   let carbsDouble = Double(carbs),
                   let fatsDouble = Double(fats),
                   !name.isEmpty else {
                 print("Invalid input") // Optional: add user feedback for invalid inputs
                 return
             }
     
     // Create a new DailyIntake object
             let newEntry = DailyIntake(
                 calories: caloriesDouble,
                 protein: proteinDouble,
                 carbs: carbsDouble,
                 fats: fatsDouble,
                 name: name
             )
     
     // Add to model context
             modelContext.insert(newEntry)
     
     
     // Save the context
             do {
                 try modelContext.save()
                 print("Food entry saved successfully!")
             } catch {
                 print("Failed to save food entry: \(error.localizedDescription)")
             }
     
     */
}


//------------------------


struct LogHomeView: View {
    var body: some View {
            NavigationView {
                ZStack {
                    // Background gradient
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    
                    // Main content
                    VStack(spacing: 20) {
                        Text("Food Tracker")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 40)

                        //Added/Log Food Entries
                        NavigationLink(destination: AddFoodEntryView()) {
                            Text("Log Food")
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        
                        NavigationLink(destination:   SearchView()) {
                            Text("Search Food")
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        
                        
                        //Saved/Logged Food Entry Not Implemented Yet
                        Button(action: {
                            print("Logged Food button tapped")
                        }) {
                            Text("Logged Food")
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                
            }
        }
}



struct LogFoodView: PreviewProvider {
    static var previews: some View {
        LogHomeView()
        AddFoodEntryView()
    }
}

