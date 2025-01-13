//  ExerciseDetailView.swift
//  Created by Luke Flannigan on 10/17/24.

import SwiftUI

struct ExerciseDetailView: View {
    var exercise: Exercise
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Image at the top
                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        if !exercise.imageName.isEmpty {
                            AsyncImage(url: URL(string: exercise.imageName)) { phase in
                                switch phase {
                                case .empty:
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width)
                                        .clipped()
                                case .failure(_):
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .overlay(
                                            Image(systemName: "photo")
                                                .foregroundColor(.gray)
                                        )
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        // Gradient overlay
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 100)
                    }
                }
                .frame(height: 300)
                
                // Back button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .offset(y: -290)
                
                // Content
                VStack(alignment: .leading, spacing: 24) {
                    // Title and Basic Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(exercise.name)
                            .font(.custom("Poppins-Bold", size: 28))
                            .foregroundColor(.primary)
                        
                        Text(exercise.type.capitalized)
                            .font(.custom("Poppins-SemiBold", size: 16))
                            .foregroundColor(.secondary)
                    }
                    
                    // Quick Stats
                    HStack(spacing: 20) {
                        if let equipment = exercise.equipment {
                            StatView(title: "Equipment", value: equipment.capitalized)
                        }
                        if let mechanic = exercise.mechanic {
                            StatView(title: "Mechanic", value: mechanic.capitalized)
                        }
                        if let force = exercise.force {
                            StatView(title: "Force", value: force.capitalized)
                        }
                    }
                    
                    // Muscles Involved
                    VStack(alignment: .leading, spacing: 16) {
                        if !exercise.primaryMuscles.isEmpty {
                            MuscleGroupView(
                                title: "Primary Muscles",
                                muscles: exercise.primaryMuscles
                            )
                        }
                        
                        if !exercise.secondaryMuscles.isEmpty {
                            MuscleGroupView(
                                title: "Secondary Muscles",
                                muscles: exercise.secondaryMuscles
                            )
                        }
                    }
                    
                    // Instructions
                    if !exercise.exerciseDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instructions")
                                .font(.custom("Poppins-Bold", size: 20))
                            
                            Text(exercise.exerciseDescription)
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                    }
                }
                .padding(20)
                .offset(y: -60) // This is the offfset to move content up
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}

// MARK: - Supporting Views
struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.secondary)
            Text(value)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.primary)
        }
    }
}

struct MuscleGroupView: View {
    let title: String
    let muscles: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Poppins-Bold", size: 20))
            
            FlowLayout(spacing: 8) {
                ForEach(muscles, id: \.self) { muscle in
                    Text(muscle.capitalized)
                        .font(.custom("Poppins-Regular", size: 14))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        return computeSize(rows: rows, proposal: proposal)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        placeRows(rows, in: bounds)
    }
    
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var currentRow: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        var currentWidth: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentWidth + size.width + spacing > (proposal.width ?? .infinity) {
                rows.append(currentRow)
                currentRow = [subview]
                currentWidth = size.width
            } else {
                currentRow.append(subview)
                currentWidth += size.width + spacing
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    private func computeSize(rows: [[LayoutSubviews.Element]], proposal: ProposedViewSize) -> CGSize {
        var height: CGFloat = 0
        var width: CGFloat = 0
        
        for row in rows {
            var rowWidth: CGFloat = 0
            var rowHeight: CGFloat = 0
            
            for subview in row {
                let size = subview.sizeThatFits(.unspecified)
                rowWidth += size.width + spacing
                rowHeight = max(rowHeight, size.height)
            }
            
            height += rowHeight + spacing
            width = max(width, rowWidth)
        }
        
        return CGSize(width: width - spacing, height: height - spacing)
    }
    
    private func placeRows(_ rows: [[LayoutSubviews.Element]], in bounds: CGRect) {
        var y = bounds.minY
        
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            
            for subview in row {
                let size = subview.sizeThatFits(.unspecified)
                subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            
            y += rowHeight + spacing
        }
    }
}

#Preview {
    NavigationView {
        ExerciseDetailView(exercise: Exercise(
            name: "Sample Exercise",
            type: "Strength",
            muscleGroup: "Chest",
            exerciseDescription: "Sample instructions",
            imageName: "",
            difficulty: .medium,
            primaryMuscles: ["Chest", "Shoulders"],
            secondaryMuscles: ["Triceps"],
            equipment: "Barbell",
            force: "Push",
            mechanic: "Compound"
        ))
    }
}

