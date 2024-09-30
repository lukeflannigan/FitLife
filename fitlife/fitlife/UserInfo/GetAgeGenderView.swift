//
//  GetUserInfoView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 9/30/24.
//

import SwiftUI
import SwiftData

struct GetAgeGenderView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var userGoals: UserGoals

    // Local state variables
    @State private var selectedGender: String = ""
    @State private var ageInput: String = "" // We'll capture age as a string to allow text input
    
    // Gender options
    let genderOptions = ["Male", "Female"]

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                
                // Title
                Text("Please select which sex we should use to calculate your calorie needs:")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                // Gender selection
                HStack {
                    ForEach(genderOptions, id: \.self) { gender in
                        Button(action: {
                            selectedGender = gender
                        }) {
                            Text(gender)
                                .font(.headline)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedGender == gender ? Color.black : Color(.systemGray5))
                                .foregroundColor(selectedGender == gender ? .white : .black)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Age Input Field
                Text("How old are you?")
                    .font(.headline)
                    .bold()
                
                TextField("Enter your age", text: $ageInput)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Text("We use biological sex at birth and age to calculate an accurate goal for you.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Next button
//                NavigationLink(destination: /* Next View */) {
//                    Text("Next")
//                        .font(.headline)
//                        .bold()
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.black)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//                .frame(height: 50)
//                .padding(.horizontal)
//                .padding(.bottom, 30)
//                .disabled(selectedGender.isEmpty || ageInput.isEmpty || Int(ageInput) == nil) // Disable if no gender or invalid age
//                .onTapGesture {
//                    // Save selected data to userGoals before navigation
//                    if let validAge = Int(ageInput) {
//                        userGoals.gender = selectedGender
//                        userGoals.age = validAge
//                        // modelContext.save() or any other action
//                    }
//                }
            }
            .navigationTitle("You")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GetUserInfoView(userGoals: .constant(UserGoals.mockUserGoals))
}
