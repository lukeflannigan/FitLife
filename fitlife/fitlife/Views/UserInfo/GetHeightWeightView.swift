//
//  GetHeightWeightView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/30/24.
//

import SwiftUI
import SwiftData

struct GetHeightWeightView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var userGoals: UserGoals
    
    // Local state variables
    @State private var heightFeet: Int = 5
    @State private var heightInches: Int = 7
    @State private var heightCentimeters: Int = 170
    @State private var useMetric: Bool = false // Toggle between Metric and Imperial units
    @State private var currentWeight: String = ""
    @State private var goalWeight: String = ""
    
    // Controls visibility of the height picker sheet
    @State private var showHeightPicker = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                
                // Unit System Picker
                Picker("Unit System", selection: $useMetric) {
                    Text("Imperial (ft, lbs)").tag(false)
                    Text("Metric (cm, kg)").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top)
                .onChange(of: useMetric) { newValue in
                    // Convert height when unit system changes
                    if newValue {
                        // Switched to Metric
                        let totalInches = Double(heightFeet * 12 + heightInches)
                        let heightCm = totalInches * 2.54
                        heightCentimeters = Int(heightCm)
                    } else {
                        // Switched to Imperial
                        let totalInches = Double(heightCentimeters) / 2.54
                        let feet = Int(totalInches / 12)
                        let inches = Int(totalInches.truncatingRemainder(dividingBy: 12))
                        heightFeet = feet
                        heightInches = inches
                    }
                }
                
                // Title
                Text("How tall are you?")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                // Height Selector (Feet/Inches or Centimeters)
                Button(action: {
                    showHeightPicker.toggle() // Show the height picker
                }) {
                    HStack {
                        if useMetric {
                            Text("\(heightCentimeters) cm")
                        } else {
                            Text("\(heightFeet) ft, \(heightInches) in")
                        }
                        Spacer()
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showHeightPicker) {
                    VStack {
                        HStack {
                            Button("Cancel") {
                                showHeightPicker = false
                            }
                            Spacer()
                            Text("Your Height")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Button("Done") {
                                showHeightPicker = false
                            }
                        }
                        .padding()
                        
                        // Height Picker based on selected unit system
                        if useMetric {
                            Picker("Height (cm)", selection: $heightCentimeters) {
                                ForEach(100...250, id: \.self) { cm in
                                    Text("\(cm) cm").tag(cm)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .pickerStyle(WheelPickerStyle())
                        } else {
                            HStack {
                                Picker("Feet", selection: $heightFeet) {
                                    ForEach(4...7, id: \.self) { feet in
                                        Text("\(feet) ft").tag(feet)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .pickerStyle(WheelPickerStyle())
                                
                                Picker("Inches", selection: $heightInches) {
                                    ForEach(0...11, id: \.self) { inches in
                                        Text("\(inches) in").tag(inches)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .pickerStyle(WheelPickerStyle())
                            }
                        }
                    }
                    .presentationDetents([.fraction(0.35)]) // Set sheet height to 35% of the screen
                }
                
                // Weight Input (Current and Goal)
                Text("How much do you weigh?")
                    .font(.headline)
                    .bold()
                
                TextField(useMetric ? "0 kg" : "0 lbs", text: $currentWeight)
                    .keyboardType(.decimalPad)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Text("It's ok to estimate, you can update this later.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Text("What's your goal weight?")
                    .font(.headline)
                    .bold()
                
                TextField(useMetric ? "0 kg" : "0 lbs", text: $goalWeight)
                    .keyboardType(.decimalPad)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Text("Don't worry, this doesn't affect your daily calorie goal and you can always change it later.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Next button wrapped in NavigationLink
                NavigationLink(destination: GetWeeklyGoalView(userGoals: $userGoals)) {
                    Text("Next")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    // Save isMetric preference
                    userGoals.isMetric = useMetric
                    
                    // Save height based on metric/imperial system
                    if useMetric {
                        userGoals.userProfile.heightInCm = Double(heightCentimeters)
                    } else {
                        userGoals.userProfile.setHeightFromImperial(feet: heightFeet, inches: heightInches)
                    }

                    // Set isMetric in userGoals
                    userGoals.isMetric = useMetric

                    // Ensure bodyMetrics has a reference to userGoals
                    userGoals.bodyMetrics.userGoals = userGoals
                    let date = Date()
                    // Save weight based on metric/imperial system
                    if let currentWeightValue = Double(currentWeight) {
                        if useMetric {
                            userGoals.bodyMetrics.currentWeightInKg = currentWeightValue // Already in kg
                            userGoals.bodyMetrics.logWeight(currentWeightValue, date: date, modelContext: modelContext)
                        } else {
                            let weightInKg = currentWeightValue * 0.453592
                            userGoals.bodyMetrics.currentWeightInKg = weightInKg
                            userGoals.bodyMetrics.logWeight(weightInKg, date: date, modelContext: modelContext)
                        }
                    }

                    if let goalWeightValue = Double(goalWeight) {
                        if useMetric {
                            userGoals.bodyMetrics.goalWeightInKg = goalWeightValue
                        } else {
                            let weightInKg = goalWeightValue * 0.453592
                            userGoals.bodyMetrics.goalWeightInKg = weightInKg
                        }
                    }
                })
                .disabled(currentWeight.isEmpty || goalWeight.isEmpty) // Disable if no weight entered
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("You")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    GetHeightWeightView(userGoals: .constant(UserGoals.mockUserGoals))
//}


