//
//  ExerciseSetView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/14/24.
//

import SwiftUI

struct ExerciseSetView: View {
    @Environment(\.modelContext) var modelContext
    @State var exerciseSet: ExerciseSet
    let setNumber: Int
    @Binding var workoutExercise: WorkoutExercise
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack{
                Color.red
                    .overlay(
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .padding(.trailing, 20), alignment: .trailing
                            
                    )
            }.frame(height: 50)
            HStack {
                Text("\(setNumber)")
                    .frame(maxWidth: .infinity)
                Text("prev")
                    .frame(maxWidth: .infinity)
                TextField("lbs", value: $exerciseSet.weight, format: .number)
                    .frame(maxWidth: .infinity)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                
                TextField("Reps", value: $exerciseSet.reps, format: .number)
                    .frame(maxWidth: .infinity)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                
                Image(systemName: "checkmark.rectangle.fill")
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 50)
            .background(Color.white)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            isSwiping = true
                            offset = gesture.translation.width
                        }
                    }
                    .onEnded { _ in
                        if offset < -50 {
                            withAnimation {
                                deleteSet()
                            }
                        }
                        withAnimation {
                            offset = 0
                            isSwiping = false
                        }
                    }
            )
            
            .clipped()
            .animation(.default, value: offset)
        }
    }
    private func deleteSet() {
        if let index = workoutExercise.sets.firstIndex(where: {$0.id == exerciseSet.id}) {
            withAnimation {
                workoutExercise.removeSet(at: IndexSet(integer: index), modelContext: modelContext)
            }
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//#Preview {
//    ExerciseSetView()
//}
