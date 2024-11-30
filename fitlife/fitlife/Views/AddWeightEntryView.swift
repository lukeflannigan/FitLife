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
    @State private var date: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Weight Entry")) {
                    TextField(weightPlaceholder(), text: $weight)
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

        // Convert to metric (kg) if necessary
        let weightInKg = userGoal?.isMetric == true ? weightValue : weightValue * 0.453592
        bodyMetrics.logWeight(weightInKg, date: date, modelContext: modelContext)
        userGoal?.setMacroGoals()
        dismiss()
    }

    private func weightPlaceholder() -> String {
        return userGoal?.isMetric == true ? "Weight (kg)" : "Weight (lbs)"
    }
}
