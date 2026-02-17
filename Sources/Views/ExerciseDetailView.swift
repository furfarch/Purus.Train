import SwiftUI

public struct ExerciseDetailView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var exercise: Exercise
    @State private var isEditing = false
    @Environment(\.dismiss) private var dismiss
    
    public init(exercise: Exercise) {
        _exercise = State(initialValue: exercise)
    }
    
    public var body: some View {
        Form {
            Section("Basic Information") {
                if isEditing {
                    TextField("Name", text: $exercise.name)
                    TextField("Description", text: $exercise.description, axis: .vertical)
                        .lineLimit(3...6)
                } else {
                    LabeledContent("Name", value: exercise.name)
                    if !exercise.description.isEmpty {
                        LabeledContent("Description", value: exercise.description)
                    }
                }
            }
            
            Section("Details") {
                if isEditing {
                    Picker("Category", selection: $exercise.category) {
                        ForEach(ExerciseCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                } else {
                    LabeledContent("Category", value: exercise.category.rawValue)
                }
                
                if !exercise.muscleGroups.isEmpty {
                    LabeledContent("Muscle Groups") {
                        Text(exercise.muscleGroups.joined(separator: ", "))
                    }
                }
            }
            
            Section("History") {
                LabeledContent("Created", value: exercise.createdDate.formatted(date: .abbreviated, time: .shortened))
                LabeledContent("Modified", value: exercise.modifiedDate.formatted(date: .abbreviated, time: .shortened))
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        dataManager.updateExercise(exercise)
                    }
                    isEditing.toggle()
                }
            }
        }
    }
}
