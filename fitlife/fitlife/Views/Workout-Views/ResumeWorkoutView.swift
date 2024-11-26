//
//  ResumeWorkoutView.swift
//  fitlife
//
//  Created by Gabriel Ciaburri on 11/14/24.
//

import SwiftUI
import SwiftData

struct ResumeWorkoutView<Content: View>: View {
    @Environment(\.currentWorkout) var currentWorkout
    @State private var showingWorkout = false

    var content: Content
    
    @ViewBuilder var body: some View {
        ZStack(alignment: .bottom) {
            content
            if currentWorkout.wrappedValue != nil {
                ZStack {
                    HStack{
                        Button(action: {
                            showingWorkout = true
                        }) {
                            HStack {
                                Image(systemName: "clock")
                                Spacer()
                                Text("Resume Workout")
                                Spacer()
                                Image(systemName: "timer")
                            }
                        }
                    }
                    .sheet(isPresented: $showingWorkout) {
                        if let _ = currentWorkout.wrappedValue {
                            NavigationStack {
                                CurrentWorkoutView(currentWorkout: currentWorkout)
                            }
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.size.width, height: 45)
                    .background(Color.white)
                    .border(.black.opacity(0.2))
                }
            }
        }
    }
}

//#Preview {
//    ResumeWorkoutView()
//}
