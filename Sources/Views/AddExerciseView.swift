import SwiftUI

public struct AddExerciseView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var category: ExerciseCategory = .strength
    @State private var selectedMuscleGroups: Set<String> = []
    
    private let availableMuscleGroups = [
        "Chest", "Back", "Shoulders", "Biceps", "Triceps",
        "Forearms", "Abs", "Obliques", "Quadriceps", "Hamstrings",
        "Glutes", "Calves", "Full Body"
    ]
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Exercise Name", text: $name)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(ExerciseCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Muscle Groups") {
                    ForEach(availableMuscleGroups, id: \.self) { muscle in
                        Toggle(muscle, isOn: Binding(
                            get: { selectedMuscleGroups.contains(muscle) },
                            set: { isSelected in
                                if isSelected {
                                    selectedMuscleGroups.insert(muscle)
                                } else {
                                    selectedMuscleGroups.remove(muscle)
                                }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExercise()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveExercise() {
        let exercise = Exercise(
            name: name,
            description: description,
            muscleGroups: Array(selectedMuscleGroups).sorted(),
            category: category
        )
        dataManager.addExercise(exercise)
        dismiss()
    }
}
