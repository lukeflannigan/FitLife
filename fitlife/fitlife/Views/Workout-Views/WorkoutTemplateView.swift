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
                .alert("Workout Template Created", isPresented: $newWorkoutClicked, actions: {
                            // default value for text input
                            TextField("My New Workout Template", text: .constant(""))
                        }, message: {
                            TextField("TextField", text: .constant("Please Enter a Name"))
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
            
            Text(template.description)
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
    let description: String
    let exercises: [WorkoutExercise]
}

