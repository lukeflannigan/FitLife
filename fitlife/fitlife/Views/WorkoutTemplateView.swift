//
//  WorkoutTemplateView.swift
//  fitlife
//
//  Created by Thomas Mendoza on 11/25/24.
//

import SwiftUI

import SwiftUI

struct WorkoutTemplateView: View {
    @State private var templates = [
        WorkoutTemplate(name: "Full Body Blast", description: "A complete workout for all muscle groups."),
        WorkoutTemplate(name: "Cardio Kick", description: "Intense cardio for fat burning."),
        WorkoutTemplate(name: "Strength Builder", description: "Focus on heavy lifts and strength gains.")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Workout Templates")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(templates, id: \.id) { template in
                            TemplateCard(template: template)
                        }
                    }
                    .padding()
                }
                
                Spacer()
        
                Button(action: {
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
}

#Preview {
    WorkoutTemplateView()
}
