//
//  WorkoutTemplateView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 11/25/24.
//

import SwiftUI

import SwiftUI

struct WorkoutTemplateView: View {
    @State private var templates: [WorkoutTemplate] = []
    @State private var newWorkoutClicked: Bool = false
    @State private var newWorkoutName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Workout Templates")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 16) {
                        if(!templates.isEmpty){
                            ForEach(templates, id: \.id) { template in
                                TemplateCard(template: template)
                            }
                        }
                        else{
                            Text("No Templates Found")
                        }
                    }
                    .padding()
                }
                
                Spacer()
        
                Button(action: { newWorkoutClicked.toggle()
                }) {
                    Text("Add New Template")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                // Stolen from: https://sarunw.com/posts/swiftui-alert-textfield/
                .alert("Add New Workout Template", isPresented: $newWorkoutClicked, actions: {
                    TextField("Enter workout name", text: $newWorkoutName)
                    Button("Save") {
                        if !newWorkoutName.isEmpty {
                            // Append to templates
                            templates.append(
                                WorkoutTemplate(
                                    name: newWorkoutName,
                                    exercises: [] // Add exercises if needed
                                )
                            )
                            print("New workout name: \(newWorkoutName)") // Print the new workout name
                            newWorkoutName = "" // Reset the input field
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        newWorkoutName = "" // Clear the input on cancel
                    }
                }, message: {
                    Text("Please enter a name for the new workout template.")
                })
            
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}

struct TemplateCard: View {
    let template: WorkoutTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(template.name)
                .font(.headline)
                .fontWeight(.bold)
            
            Text("\(template.exercises.count) exercises")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Button(action: {
                }) {
                    Text("Edit")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("Use")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("Delete")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

struct WorkoutTemplate: Identifiable {
    let id = UUID()
    let name: String
    let exercises: [WorkoutExercise]
}

