//
//  AddWeightEntryView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/5/24.
//

import SwiftUI
import SwiftData

struct AddWeightEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    var userGoal: UserGoals?
    
    @State private var weight: String = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Weight Entry")) {
                    TextField("Weight", text: $weight)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button(action: addWeightEntry) {
                        Text("Save")
                            .bold()
                    }
                }
            }
            .navigationTitle("Add Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addWeightEntry() {
        guard let weightValue = Double(weight), let bodyMetrics = userGoal?.bodyMetrics else { return }
        
        let newEntry = BodyWeightEntry(date: date, weight: weightValue)
        bodyMetrics.bodyWeightLog.append(newEntry)
        
        try? modelContext.save() // Save the new entry to the database
        dismiss()
    }
}
