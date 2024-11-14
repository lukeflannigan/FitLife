import SwiftUI

struct ActiveWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var workout: Workout
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showingExerciseSelection = false
    
    var formattedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Timer Display
                VStack(spacing: 8) {
                    Text("Workout Duration")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.secondary)
                    Text(formattedTime)
                        .font(.custom("Poppins-Bold", size: 36))
                        .monospacedDigit()
                        .foregroundColor(.black)
                }
                .padding(.top, 32)
                
                Spacer()
                
                // Empty Setup for now will add actual exercises here
                VStack(spacing: 16) {
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No exercises added yet")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Add Exercise Button
                Button(action: {
                    showingExerciseSelection = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Exercise")
                            .font(.custom("Poppins-SemiBold", size: 16))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Finish") { 
                        timer?.invalidate()
                        dismiss()
                    }
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                elapsedTime += 1
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

#Preview {
    ActiveWorkoutView(workout: Workout.mockWorkoutEntry)
} 
