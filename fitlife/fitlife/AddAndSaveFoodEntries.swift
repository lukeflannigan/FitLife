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
    
    
    
    var body: some View{
        Form {
            Section(header: Text("Log Your Food Intake").font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 10)) {
                    TextField("What did you eat?", text: $name)
                    TextField("Calories", text: $calories)
                        .keyboardType(.decimalPad)
                    TextField("Protein (g)", text: $protein)
                        .keyboardType(.decimalPad)
                    TextField("Carbohydrates (g)", text: $carbs)
                        .keyboardType(.decimalPad)
                    TextField("Fats (g)", text: $fats)
                        .keyboardType(.decimalPad)
                }
            
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
        .navigationTitle("Add Food Entry")
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

struct LogFoodView: PreviewProvider {
    static var previews: some View {
        AddFoodEntryView()
    }
}

